extends TileMap

const tent_front = preload("res://Structures/Tent/TentFront.tscn")
const tent_back = preload("res://Structures/Tent/TentBack.tscn")
const friendly_banner = preload("res://Structures/Banner/FriendlyBanner.tscn")
const oak_tree = preload("res://World/Trees/Oak/OakTree.tscn")
const teepee = preload("res://Structures/Tent/Teepee.tscn")

func _ready():
	for tile_position in get_used_cells_by_id(tile_set.find_tile_by_name("TentFront")):
		var tent = tent_front.instance()
		tent.position = map_to_world(tile_position) + Vector2(16, 16)
		get_parent().get_node("GlobalYSort/World").add_child(tent)
		set_cellv(tile_position, -1)
	for tile_position in get_used_cells_by_id(tile_set.find_tile_by_name("TentBack")):
		var tent = tent_back.instance()
		tent.position = map_to_world(tile_position) + Vector2(16, 16)
		get_parent().get_node("GlobalYSort/World").add_child(tent)
		set_cellv(tile_position, -1)
	for tile_position in get_used_cells_by_id(tile_set.find_tile_by_name("FriendlyBanner")):
		var banner = friendly_banner.instance()
		banner.position = map_to_world(tile_position) + Vector2(8, 26)
		get_parent().get_node("GlobalYSort/World").add_child(banner)
		set_cellv(tile_position, -1)
	for tile_position in get_used_cells_by_id(tile_set.find_tile_by_name("OakTree")):
		var structure = oak_tree.instance()
		structure.position = map_to_world(tile_position) + Vector2(48, 120)
		get_parent().get_node("GlobalYSort/World").add_child(structure)
		set_cellv(tile_position, -1)
	for tile_position in get_used_cells_by_id(tile_set.find_tile_by_name("Teepee")):
		var structure = teepee.instance()
		structure.position = map_to_world(tile_position) + Vector2(24, 57)
		get_parent().get_node("GlobalYSort/World").add_child(structure)
		set_cellv(tile_position, -1)
