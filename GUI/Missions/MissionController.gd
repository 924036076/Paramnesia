extends Node

var current_missions
var following = null

func _ready():
	current_missions = [["Mission 1", "Description for mission 1", true], ["Mission 2", "Description for mission 2", false], ["Mission 2", "Description for mission 2", false], ["Mission 3", "Description for mission 3", false], ["Mission 4", "Description for mission 4", false], ["Mission 5", "Description for mission 5", false]]

func delete_mission(mission):
	if mission == following:
		following = null
	current_missions.erase(mission)

func follow_mission(mission):
	following = mission

func clear_following():
	following = null
