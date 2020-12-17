extends Control

const MissionBox = preload("res://GUI/Missions/Mission.tscn")

onready var vbox = get_node("ScrollContainer/VBoxContainer")

var test_mission = {
		"id": 0,
		"title": "Craft an axe",
		"description": "Gather wood and stone to craft an axe",
		"required": true,
		"prereqs": [],
		"type": "item",
		"item_list": [["stone_axe", 1], ["apple", 15]]
		}
var test_mission2 = {
	"id": -1,
	"title": "Test Mission 2",
	"description": "Gather wood and stone to craft an axe Gather wood and stone to craft an axe Gather wood and stone to craft an axe",
	"required": false,
	"prereqs": [],
	"type": "none"
	}

func _ready():
	var test_mission_box = MissionBox.instance()
	test_mission_box.mission = test_mission
	vbox.add_child(test_mission_box)
	
	test_mission_box = MissionBox.instance()
	test_mission_box.mission = test_mission2
	vbox.add_child(test_mission_box)
	
	get_node("NoMissions").visible = false
	return
	
	for mission in MissionController.active_missions:
		var mission_box = MissionBox.instance()
		mission_box.mission = mission
		vbox.add_child(mission_box)
		get_node("NoMissions").visible = false
