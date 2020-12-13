extends Position2D

func get_damage():
	return get_parent().get_damage()

func get_knockback():
	return get_parent().get_knockback()
