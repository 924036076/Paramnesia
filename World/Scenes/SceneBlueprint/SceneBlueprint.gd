extends Node2D

class_name RootScene

onready var pathfinding = get_node("Pathfinding")
onready var tilemap = get_node("TileMap")

export(String, FILE) var save_path
export var key: String

var item_spawn_distance: int = 64

enum {
	EASY,
	NORMAL,
	HARD
}

func _ready():
	pathfinding.create_navigation_map(tilemap)
	add_other_tilemaps()
	var nodes = get_tree().get_nodes_in_group("Pathfinding")
	for node in nodes:
		node.initialize(pathfinding)

func initialize():
	var used_points: Array = []
	var starting_pos = get_node("SpawnArea").rect_global_position
	var bounds = get_node("SpawnArea").rect_size
	used_points.append(Vector2(starting_pos.x + bounds.x / 2, starting_pos.y + bounds.y / 2))
	
# Starting animals
	var creatures = ["Cow", "Pig", "Goat", "Chicken", "Sheep", "Rabbit"]
	for creature in creatures:
		for _i in range(Global.starting_items[creature.to_lower()]):
			var cage = load("res://Structures/Cage/Cage.tscn").instance()
			cage.creature = creature
			cage.level = 1
			cage.global_position = get_point_in_spawn_area(used_points)
			get_node("GlobalYSort/World").add_child(cage)
	
	PlayerData.coins = Global.starting_items["coin"] * 10 + int(rand_range(0, (2 - Global.difficulty) * 10))
	
# Starting items
	var sacks: Array = []
	for _i in range(4):
		var sack = load("res://Structures/ItemSack/ItemSack.tscn").instance()
		sacks.append(sack)
		sack.global_position = get_point_in_spawn_area(used_points)
		get_node("GlobalYSort/World").add_child(sack)
	
	var starting_items: Array
	match Global.difficulty:
		EASY:
			starting_items = Global.embark_loot_table.roll_table(1, 30)
		NORMAL:
			starting_items = Global.embark_loot_table.roll_table(1, 20)
		HARD:
			starting_items = Global.embark_loot_table.roll_table(1, 10)
	
	var current_sack: int = 0
	for i in range(starting_items.size()):
		var sack = sacks[current_sack]
		sack.inventory.append(starting_items[i])
		if sack.inventory.size() == 1:
			if randi() % 2 == 1:
				current_sack += 1
		else:
			current_sack += 1
		if current_sack >= 4:
			current_sack = 0

	get_node("SpawnArea").queue_free()

func get_point_in_spawn_area(used_points):
	var starting_pos = get_node("SpawnArea").rect_global_position
	var bounds = get_node("SpawnArea").rect_size
	
	var x: int = randi() % int(bounds.x / item_spawn_distance + 1)
	x = x * item_spawn_distance + starting_pos.x
	var y: int = randi() % int(bounds.y / item_spawn_distance + 1)
	y = y * item_spawn_distance + starting_pos.y
	
	var tries: int = 0
	while(Vector2(x, y) in used_points):
		x = randi() % int(bounds.x / item_spawn_distance + 1)
		x = x * item_spawn_distance + starting_pos.x
		y = randi() % int(bounds.y / item_spawn_distance + 1)
		y = y * item_spawn_distance + starting_pos.y
		
# warning-ignore:narrowing_conversion
		x = clamp(x, starting_pos.x, starting_pos.x + bounds.x)
# warning-ignore:narrowing_conversion
		y = clamp(y, starting_pos.y, starting_pos.y + bounds.y)
		
		tries += 1
		if tries > 200:
			print("ERROR: Not enough spawn space")
			break
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
