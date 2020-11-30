extends Control

var mission
var required: bool = false

onready var background = get_node("Background")
onready var descr_label = get_node("Description")

func _ready():
	get_node("Title").text = mission[0]
	descr_label.text = mission[1]
	required = mission[2]
	
	rect_min_size.y += descr_label.rect_size.y + 4
	background.rect_size.y += descr_label.rect_size.y + 4
	
	if required:
		get_node("DeleteButton").queue_free()
	
	if mission == MissionController.following:
		var missions = get_tree().get_nodes_in_group("Mission")
		for node in missions:
			node.reset_background()
		background.texture = load("res://GUI/Missions/mission_box_highlighted.png")
		get_node("LocateButton").toggle_mode = true

func _on_DeleteButton_pressed():
	if not required:
		MissionController.delete_mission(mission)
		queue_free()

func _on_LocateButton_toggled(button_pressed):
	if button_pressed:
		MissionController.follow_mission(mission)
		var missions = get_tree().get_nodes_in_group("Mission")
		for node in missions:
			node.reset_background()
		background.texture = load("res://GUI/Missions/mission_box_highlighted.png")
	else:
		background.texture = load("res://GUI/Missions/mission_box.png")
		MissionController.clear_following()

func reset_background():
	background.texture = load("res://GUI/Missions/mission_box.png")
