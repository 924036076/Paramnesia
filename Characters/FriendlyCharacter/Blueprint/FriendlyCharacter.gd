extends Character

class_name FriendlyCharacter

const floating_numbers = preload("res://Effects/DamageNumbers/EnemyNumbers.tscn")

export var CAN_ATTACK: bool = true

func floating_damage_numbers(damage):
	var numbers = floating_numbers.instance()
	numbers.text = str(damage)
	add_child(numbers)
