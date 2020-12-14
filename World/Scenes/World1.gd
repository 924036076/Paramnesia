extends RootScene

func add_other_tilemaps():
	pathfinding.add_tilemap_to_navigation(get_node("WaterTilemap"))
	pathfinding.add_tilemap_to_navigation(get_node("FarmTilemap"))
