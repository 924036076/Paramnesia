extends Node2D

class_name RootScene

onready var pathfinding = get_node("Pathfinding")
onready var tilemap = get_node("TileMap")

export(String, FILE) var save_path
export var key: String

func _ready():
	pathfinding.create_navigation_map(tilemap)
	add_other_tilemaps()
	var nodes = get_tree().get_nodes_in_group("Pathfinding")
	for node in nodes:
		node.initialize(pathfinding)

func add_other_tilemaps():
	pass

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
		"swordsman":
			spawn = load("res://Characters/NPCs/Skeleton/Swordsman/SkeletonSwordsman.tscn").instance()
	if (xcoord == -37 and ycoord == 37):
		spawn.global_position = get_node("GlobalYSort/Player").global_position
	else:
		spawn.global_position = Vector2(xcoord, ycoord)
	get_node("GlobalYSort/Mobs").add_child(spawn)
