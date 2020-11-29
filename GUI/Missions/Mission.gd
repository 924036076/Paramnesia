extends Control

export var title: String = ""
export var description: String = ""
var required: bool = false

onready var background = get_node("Background")
onready var descr_label = get_node("Description")

func _ready():
	get_node("Title").text = title
	descr_label.text = description
	if required:
		get_node("DeleteButton").queue_free()

func _on_InfoButton_toggled(button_pressed):
	if button_pressed:
		descr_label.visible = true
		rect_min_size.y += descr_label.rect_size.y + 4
		background.rect_size.y += descr_label.rect_size.y + 4
	else:
		rect_min_size.y = 32
		background.rect_size.y = 32
		descr_label.visible = false

func _on_DeleteButton_pressed():
	if not required:
		queue_free()

func _on_DownButton_pressed():
	var parent = get_parent()
	parent.remove_child(self)
	parent.add_child(self)
