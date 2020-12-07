extends Node2D

export(String, FILE) var save_path
export var key: String

func load_from_save():
	return

func teleport(xcoord, ycoord):
	get_node("GlobalYSort/Player").global_position = Vector2(xcoord, ycoord)

func spawn_mob(mob, xcoord, ycoord):
	var spawn
	match mob:
		"deer":
			spawn = load("res://Characters/Mobs/Deer/Deer.tscn").instance()
		"archer":
			spawn = load("res://Characters/NPCs/Skeleton/Archer/SkeletonArcher.tscn").instance()
	if (xcoord == -37 and ycoord == 37):
		spawn.global_position = get_node("GlobalYSort/Player").global_position
	else:
		spawn.global_position = Vector2(xcoord, ycoord)
	get_node("GlobalYSort/Mobs").add_child(spawn)
