extends TileMap

var region_x = 0

func _on_Timer_timeout():
	region_x += 1
	if region_x > 2:
		region_x = 0
	tile_set.tile_set_region(0, Rect2(region_x * 96, 64, 80, 112))
