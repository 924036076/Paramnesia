extends Node

class_name MultiPoolLootTable

var json_dict: Dictionary

func _init(dict: Dictionary):
	json_dict = dict

func roll_table(roll_multiplier: float = 1.0) -> Array:
	randomize()
	
	var results_array: Array = []
	
	for pool in json_dict["pools"].keys():
		var rolls: int = json_dict["pools"][pool]
		if rolls < 1:
			return results_array
		var table: Dictionary = json_dict[pool]
		var total_probability: float = 0.0
		for key in table:
			total_probability += table[key]["weight"]
		for _i in range(rolls * roll_multiplier):
			roll_one(results_array, total_probability, table)
	return results_array

func roll_one(results_array: Array, total_probability: float, table: Dictionary):
	var running_total: float = 0
	var hit: float = rand_range(0.0, total_probability)
	
	for key in table:
		running_total += table[key]["weight"]
		if running_total >= hit:
			var minimum_price = table[key]["minimum_price"]
			var maximum_price = table[key]["maximum_price"]
			var price: float = rand_range(minimum_price, maximum_price)
			var minimum_amount = table[key]["minimum_amount"]
			var maximum_amount = table[key]["maximum_amount"]
			var amount: float = rand_range(minimum_amount, maximum_amount)
			var adjusted_price: int = int(amount * price)
			results_array.append([key, int(amount), adjusted_price])
			break
