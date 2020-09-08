extends Node2D

class_name SpawnNode

func spawn_item(spawn_table):
	var total = 0
	
	for item in spawn_table:
		total += item[0]
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var pick = rng.randi_range(0, total)
	
	total = 0
	var spawn
	
	for item in spawn_table:
		total += item[0]
		if total >= pick:
			if item[1] == null:
				return
			spawn = item[1].instance()
			break

	spawn.position = spawn.position + Vector2(rng.randi_range(-25, 25), rng.randi_range(-25, 25))
	add_child(spawn)
