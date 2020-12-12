extends Node

var completed_missions = []
var active_missions = []

const notification = preload("res://Control/Missions/Notification.tscn")

func check_prereqs(prereqs):
	for req in prereqs:
		if not req in completed_missions:
			return false
	return true

func start_mission(m):
	if not m in active_missions:
		active_missions.append(m)
		var n = notification.instance()
		n.text = "Mission Started: " + m["title"]
		var gui = get_tree().get_current_scene().get_node("GUI")
		gui.add_child(n)
		gui.new_mission()

func delete_mission(m):
	if not m["required"]:
		active_missions.remove(m)
