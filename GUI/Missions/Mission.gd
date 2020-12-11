extends Control

onready var tween = get_node("Tween")

var mission
var required: bool = false

onready var background = get_node("Background")
onready var descr_label = get_node("Description")

func _ready():
	get_node("Title").text = mission["title"]
	descr_label.text = mission["description"]
	required = mission["required"]
	
	if required:
		get_node("DeleteButton").queue_free()

func _on_DeleteButton_pressed():
	if not required:
		MissionController.delete_mission(mission)
		queue_free()

func _on_ExpandButton_toggled(button_pressed):
	if button_pressed:
		descr_label.visible = true
		rect_min_size.y += descr_label.rect_size.y + 8
		tween.interpolate_property(background, "rect_size", Vector2(320, 24), Vector2(320, 24 + descr_label.rect_size.y + 8), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	else:
		rect_min_size.y = 24
		tween.interpolate_property(background, "rect_size", Vector2(320, 24 + descr_label.rect_size.y + 8), Vector2(320, 24), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		descr_label.visible = false
