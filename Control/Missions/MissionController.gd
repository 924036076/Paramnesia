extends Node

const notification = preload("res://Control/Missions/Notification.tscn")

var completed_missions = []
var active_missions = []

func check_prereqs(prereqs):
	for req in prereqs:
		if not req in completed_missions:
			return false
	return true

func can_start(m):
	return (not m["id"] in completed_missions) and (not m in active_missions) and check_prereqs(m["prereqs"])

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
		active_missions.erase(m)

func player_inventory_changed():
	if active_missions.size() < 1:
		return
	for m in active_missions:
		if m["type"] == "item":
			if PlayerData.has_items(m["item_list"]):
				mission_done(m)

func mission_done(m):
	active_missions.erase(m)
	completed_missions.append(m["id"])
	if m["reward"] == "item":
		PlayerData.add_list_to_inventory(0, m["reward_items"])
	var n = notification.instance()
	n.text = "Mission Completed: " + m["title"]
	var gui = get_tree().get_current_scene().get_node("GUI")
	gui.add_child(n)
	gui.new_mission()
