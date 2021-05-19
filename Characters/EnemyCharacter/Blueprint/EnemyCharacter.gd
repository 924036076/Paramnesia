extends Character

class_name EnemyCharacter

const floating_numbers = preload("res://Effects/DamageNumbers/FriendlyNumbers.tscn")

export var SPECIES: String = ""

var level: int = 1

func extra_init():
	get_node("Name").text = get_name()
	get_node("Name").visible = false

func floating_damage_numbers(damage):
	var numbers = floating_numbers.instance()
	numbers.text = str(damage)
	add_child(numbers)

func get_name() -> String:
	return SPECIES + " - Lvl " + str(level)

func mouse_entered():
	get_node("Name").visible = true

func mouse_exited():
	get_node("Name").visible = false

