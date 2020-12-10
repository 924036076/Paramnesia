extends Control

var mission
var required: bool = false

onready var background = get_node("Background")
onready var descr_label = get_node("Description")

func _ready():
	get_node("Title").text = mission["title"]
	descr_label.text = mission["description"]
	required = mission["required"]
	
	rect_min_size.y += descr_label.rect_size.y + 4
	background.rect_size.y += descr_label.rect_size.y + 4
	
	if required:
		get_node("DeleteButton").queue_free()

func _on_DeleteButton_pressed():
	if not required:
		MissionController.delete_mission(mission)
		queue_free()
