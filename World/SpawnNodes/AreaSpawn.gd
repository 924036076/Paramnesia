extends Node2D

class_name AreaSpawn

func spawn_items(item, frequency, spawn_range):
	var start = Vector2(spawn_range[0])
	var end = Vector2(spawn_range[1])
	var area = (end.x - start.x) * (end.y - start.y)
	var num = int(area * frequency)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	for _i in range(num):
		var item_position = Vector2(rng.randi_range(start.x, end.x), rng.randi_range(start.y, end.y))
		var spawn = item.instance()
		spawn.position = item_position
		add_child(spawn)
