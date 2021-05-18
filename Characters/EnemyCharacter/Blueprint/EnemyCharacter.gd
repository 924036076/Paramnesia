extends Character

class_name EnemyCharacter

const floating_numbers = preload("res://Effects/DamageNumbers/FriendlyNumbers.tscn")

export var CAN_TAME: bool = false
export var SPECIES: String = ""
export var WANDER_TIME: float = 2.0

var level: int = 1

func extra_init():
	get_node("Name").text = get_name()
	get_node("Name").visible = false
	get_node("WanderTimer").wait_time = WANDER_TIME

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

func _on_WanderTimer_timeout():
	choose_new_action()

func choose_new_action():
	pass
