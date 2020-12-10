extends Node

var completed_missions = []
var active_missions = []

func check_prereqs(prereqs):
	for req in prereqs:
		if not req in completed_missions:
			return false
	return true

func start_mission(m):
	if not m in active_missions:
		active_missions.append(m)

func delete_mission(m):
	if not m["required"]:
		active_missions.remove(m)
