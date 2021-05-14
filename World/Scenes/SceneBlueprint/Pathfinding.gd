extends Node2D

export var enabled_color: Color
export var disabled_color: Color

onready var grid = get_node("Grid")

var grid_rects := {}
var static_blocked_tiles: Array = []
var astar = AStar2D.new()
var tilemap: TileMap
var half_cell_size: Vector2
var used_rect: Rect2
var do_diagonals: bool = false
export var debug: bool = false

func create_navigation_map(passed_tilemap: TileMap):
	tilemap = passed_tilemap
	
	half_cell_size = tilemap.cell_size / 2
	used_rect = tilemap.get_used_rect()
	
	var tiles = tilemap.get_used_cells()
	
	add_traversable_tiles(tiles)
	connect_traversable_tiles(tiles)
	add_obstacles()

func add_structure(structure):
	var obstacles = get_tree().get_nodes_in_group("Obstacle")
	for obstacle in obstacles:
		if obstacle.get_parent() == structure:
			var tile_coord = tilemap.world_to_map(obstacle.global_position)
			var id = get_id(tile_coord)
			if astar.has_point(id):
				astar.set_point_disabled(id, true)
				if debug:
					grid_rects[str(id)].color = disabled_color

func remove_structure(structure):
	var obstacles = get_tree().get_nodes_in_group("Obstacle")
	for obstacle in obstacles:
		if obstacle.get_parent() == structure:
			var tile_coord = tilemap.world_to_map(obstacle.global_position)
			var id = get_id(tile_coord)
			if astar.has_point(id) and not id in static_blocked_tiles:
				astar.set_point_disabled(id, false)
				if debug:
					grid_rects[str(id)].color = enabled_color

func add_obstacles():
	var obstacles = get_tree().get_nodes_in_group("Obstacle")
	for obstacle in obstacles:
		var rectangles: Array = obstacle.get_pathfinding_rectangles()
		for r in rectangles:
			var tile_coord = tilemap.world_to_map(r)
			var id = get_id(tile_coord)
			if astar.has_point(id):
				astar.set_point_disabled(id, true)
				if debug:
					grid_rects[str(id)].color = disabled_color

func add_traversable_tiles(tiles: Array):
	for tile in tiles:
		var id = get_id(tile)
		astar.add_point(id, tile)
	
		if debug:
			var rect: ColorRect = ColorRect.new()
			grid.add_child(rect)
			grid_rects[str(id)] = rect
			rect.modulate = Color(1, 1, 1, 0.5)
			rect.color = enabled_color
			rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
			rect.rect_size = tilemap.cell_size
			rect.rect_position = tilemap.map_to_world(tile)

func connect_traversable_tiles(tiles: Array):
	for tile in tiles:
		var id = get_id(tile)
		
		if do_diagonals:
			for x in range(3):
				for y in range(3):
					var target = tile + Vector2(x - 1, y - 1)
					var target_id = get_id(target)
				
					if tile == target or not astar.has_point(target_id):
						continue
				
					astar.connect_points(id, target_id, true)
		else:
			var points = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
			for point in points:
				var target = tile + point
				var target_id = get_id(target)
				
				if tile == target or not astar.has_point(target_id):
					continue
				
				astar.connect_points(id, target_id, true)

func add_tilemap_to_navigation(passed_tilemap: TileMap):
	var tiles = passed_tilemap.get_used_cells()
	for tile in tiles:
		var id = get_id(tile)
		if astar.has_point(id):
			astar.set_point_disabled(id, true)
			if not id in static_blocked_tiles:
				static_blocked_tiles.append(id)
			if debug:
				grid_rects[str(id)].color = disabled_color

func get_id(point: Vector2):
	var x = point.x - used_rect.position.x
	var y = point.y - used_rect.position.y
	
	return x + y * used_rect.size.x

#params are world coordinates
func get_new_path(start: Vector2, end: Vector2):
	var start_tile = tilemap.world_to_map(start)
	var end_tile = tilemap.world_to_map(end)
	
	var start_id = get_id(start_tile)
	var end_id = get_id(end_tile)
	
	if not astar.has_point(start_id) or not astar.has_point(end_id):
		return []
	
	var path_map = astar.get_point_path(start_id, end_id)
	var path_world = []
	for point in path_map:
		var point_world = tilemap.map_to_world(point) + half_cell_size
		path_world.append(point_world)
	
	return path_world
