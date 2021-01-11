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

func initialize():
	
	var cage = load("res://Structures/Cage/Cage.tscn").instance()
	cage.creature = "Cow"
	cage.level = 5
	get_node("GlobalYSort/World").add_child(cage)
	
	cage = load("res://Structures/Cage/Cage.tscn").instance()
	cage.creature = "empty"
	get_node("GlobalYSort/World").add_child(cage)
	cage.global_position.x -= 50
	
	var _used_points = []
	#spawn in resources here
	get_node("SpawnArea").queue_free()

func get_point_in_spawn_area(used_points):
	var starting_pos = get_node("SpawnArea").rect_global_position
	var bounds = get_node("SpawnArea").rect_size
	
	var x: int = randi() % int(bounds.x / 32) + 1
	x = x * 32 + starting_pos.x
	var y: int = randi() % int(bounds.y / 32) + 1
	y = y * 32 + starting_pos.y
	
	while(Vector2(x, y) in used_points):
		x = randi() % int(bounds.x / 32) + 1
		x = y * 32 + starting_pos.x
		y = randi() % int(bounds.y / 32) + 1
		y = y * 32 + starting_pos.y
	
	used_points.append(Vector2(x, y))
	return Vector2(x, y)

func add_other_tilemaps():
	pass

func load_from_save():
	return

func teleport(xcoord, ycoord):
	get_node("GlobalYSort/Player").global_position = Vector2(xcoord, ycoord)

func set_gui_window(i):
	get_node("GUI").current_window = i

func close_gui_window():
	get_node("GUI").close_open_window()

func spawn_mob(mob, xcoord, ycoord):
	var spawn
	match mob:
		#tamed
		"cow":
			spawn = load("res://Characters/Mobs/Tamed/Cow/Cow.tscn").instance()
		#wild
		"deer":
			spawn = load("res://Characters/Mobs/Wild/Deer/Deer.tscn").instance()
		"archer":
			spawn = load("res://Characters/NPCs/Skeleton/Archer/SkeletonArcher.tscn").instance()
		"swordsman":
			spawn = load("res://Characters/NPCs/Skeleton/Swordsman/SkeletonSwordsman.tscn").instance()
	get_node("GlobalYSort/Mobs").add_child(spawn)
	if (xcoord == -10000 and ycoord == 10000):
		spawn.global_position = get_node("GlobalYSort/Player").global_position
	else:
		spawn.global_position = Vector2(xcoord, ycoord)
	return spawn
