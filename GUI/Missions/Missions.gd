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
		"item_list": [["stone_axe", 1], ["apple", 15]],
		"reward": "item",
		"reward_items": [["campfire", 1]]
		}
var test_mission2 = {
	"id": 1,
	"title": "Test Mission 2",
	"description": "Gather wood and stone to craft an axe Gather wood and stone to craft an axe Gather wood and stone to craft an axe",
	"required": false,
	"prereqs": [],
	"type": "none",
	"reward": "blueprint",
	"blueprint": "cooking_pot"
	}
var test_mission3 = {
	"id": 2,
	"title": "Test Mission 3",
	"description": "Gather wood and stone to craft an axe Gather wood and stone to craft an axe Gather wood and stone to craft an axe",
	"required": false,
	"prereqs": [],
	"type": "item",
	"item_list": [["stone_axe", 1], ["apple", 15]],
	"reward": "item",
	"reward_items": [["campfire", 1]]
	}

func _ready():
	#debug_missions()
	#return
	for mission in MissionController.active_missions:
		var mission_box = MissionBox.instance()
		mission_box.mission = mission
		mission_box.connect("expand", self, "mission_expanded")
		vbox.add_child(mission_box)
		get_node("NoMissions").visible = false

func mission_expanded(node):
	for mission in get_node("ScrollContainer/VBoxContainer").get_children():
		if mission != node:
			mission.collapse()

func debug_missions():
	var test_mission_box = MissionBox.instance()
	test_mission_box.mission = test_mission
	test_mission_box.connect("expand", self, "mission_expanded")
	vbox.add_child(test_mission_box)
	
	test_mission_box = MissionBox.instance()
	test_mission_box.mission = test_mission2
	test_mission_box.connect("expand", self, "mission_expanded")
	vbox.add_child(test_mission_box)
	
	test_mission_box = MissionBox.instance()
	test_mission_box.mission = test_mission3
	test_mission_box.connect("expand", self, "mission_expanded")
	vbox.add_child(test_mission_box)
	
	get_node("NoMissions").visible = false
	return
	
