extends Node

class_name ItemStack

var id: String = ""
var amount: int = 0

func _init(passed_id: String, passed_amount: int):
	id = passed_id
	amount = passed_amount

func setup(passed_id: String, passed_amount: int):
	id = passed_id
	amount = passed_amount

func room_left_in_stack() -> int:
	return ItemDictionary.get_item(id)["stack"] - amount
