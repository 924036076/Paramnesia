extends Position2D

func get_damage():
	return get_parent().get_damage()
