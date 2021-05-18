extends Position2D

func get_damage():
	return get_parent().get_damage()

func get_knockback():
	return get_parent().get_knockback()

func get_damage_info() -> Dictionary:
	var damage: Dictionary = {
		"damage": get_parent().get_damage(),
		"reference": get_parent()
	}
	return damage
