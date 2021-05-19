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
var do_diagonals: bool = true

func create_navigation_map(passed_tilemap: TileMap):
	tilemap = passed_tilemap
	
	half_cell_size = tilemap.cell_size / 2
	used_rect = tilemap.get_used_rect()
	
	var tiles = tilemap.get_used_cells()
	
	add_traversable_tiles(tiles)
	connect_traversable_tiles(tiles)
	add_obstacles()

func add_obstacles():
	var obstacles = get_tree().get_nodes_in_group("Obstacle")
	for obstacle in obstacles:
		var rectangles: Array = obstacle.get_pathfinding_rectangles()
		for r in rectangles:
			var tile_coord = tilemap.world_to_map(r)
			var id = get_id(tile_coord)
			if astar.has_point(id):
				astar.set_point_disabled(id, true)
				if Global.debug_show_path_grid:
					grid_rects[str(id)].color = disabled_color

func add_traversable_tiles(tiles: Array):
	for tile in tiles:
		var id = get_id(tile)
		astar.add_point(id, tile)
	
		if Global.debug_show_path_grid:
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

func get_id(point: Vector2):
	var x = point.x - used_rect.position.x
	var y = point.y - used_rect.position.y
	
	return x + y * used_rect.size.x

#params are world coordinates
func get_new_path(start: Vector2, end: Vector2, allow_nearest_alternative: bool = false, search_distance: int = 2) -> Array:
	var start_tile = tilemap.world_to_map(start)
	var end_tile = tilemap.world_to_map(end)
	
	var start_id = get_id(start_tile)
	var end_id = get_id(end_tile)
	
	if not astar.has_point(start_id):
		if not allow_nearest_alternative:
			return []
		
		#check the tiles surrounding the start to see if a valid one is nearby
		var nearest_point: Vector2 = end
		for x in range(-search_distance, search_distance + 1):
			for y in range(-search_distance, search_distance + 1):
				var new_coord: Vector2 = Vector2(x, y) * 16 + start
				if astar.has_point(get_id(tilemap.world_to_map(new_coord))):
					if start.distance_to(new_coord) < start.distance_to(nearest_point):
						nearest_point = new_coord
		if nearest_point == end:
			return []
		
		start_tile = tilemap.world_to_map(nearest_point)
		start_id = get_id(start_tile)

	if not astar.has_point(end_id):
		if not allow_nearest_alternative:
			return []
		
		#check the tiles surrounding the end to see if a valid one is nearby
		var nearest_point: Vector2 = start
		for x in range(-search_distance, search_distance + 1):
			for y in range(-search_distance, search_distance + 1):
				var new_coord: Vector2 = Vector2(x, y) * 16 + end
				if astar.has_point(get_id(tilemap.world_to_map(new_coord))):
					if end.distance_to(new_coord) < end.distance_to(nearest_point):
						nearest_point = new_coord
		if nearest_point == start:
			return []
		
		end_tile = tilemap.world_to_map(nearest_point)
		end_id = get_id(end_tile)
	
	#generate path
	var path_map = astar.get_point_path(start_id, end_id)
	var path_world = []
	for point in path_map:
		var point_world = tilemap.map_to_world(point) + half_cell_size
		path_world.append(point_world)
	
	return path_world

func is_valid_path(start: Vector2, end: Vector2, allow_nearest_alternative: bool = false, search_distance: int = 2) -> bool:
	if start.distance_to(end) < search_distance * 16:
		return true
	var path = get_new_path(start, end, allow_nearest_alternative, search_distance)
	return (path.size() > 0)
