extends Node2D

var astar = AStar2D.new()
var tilemap: TileMap
var half_cell_size: Vector2
var used_rect: Rect2
var do_diagonals: bool = false

func create_navigation_map(passed_tilemap: TileMap):
	tilemap = passed_tilemap
	
	half_cell_size = tilemap.cell_size / 2
	used_rect = tilemap.get_used_rect()
	
	var tiles = tilemap.get_used_cells()
	
	add_traversable_tiles(tiles)
	connect_traversable_tiles(tiles)

func add_traversable_tiles(tiles: Array):
	for tile in tiles:
		var id = get_id(tile)
		astar.add_point(id, tile)

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
