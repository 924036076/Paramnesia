extends Position2D

func get_damage_info() -> Dictionary:
	var damage: Dictionary = {
		"damage": get_parent().base_melee_damage,
		"reference": get_parent(),
		"knockback" : get_parent().dir * get_parent().KNOCKBACK_STRENGTH,
		"type" : "tame"
	}
	return damage
