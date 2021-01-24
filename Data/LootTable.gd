extends Node

class_name LootTable

var rolls: int = 0
var bonus_rolls: int = 0
var total_probability: float = 0.0
var entries: Dictionary

func _init(dict: Dictionary):
	rolls = dict["rolls"]
	bonus_rolls = dict["bonus_rolls"]
	entries = dict["entries"]
	
	for key in entries.keys():
		total_probability += entries[key]

func roll_table(luck: float = 0, roll_multiplier: float = 1.0) -> Array:
	randomize()
	
	var results_array: Array = []
	
	for _i in range(rolls * roll_multiplier + int(bonus_rolls * luck * roll_multiplier)):
		roll_one(results_array)
	
	return results_array

func roll_one(results_array: Array):
	var running_total: float = 0
	var hit: float = rand_range(0.0, total_probability)
	var stack_flag: bool = false
	
	var hit_item
	
	for key in entries.keys():
		running_total += entries[key]
		if running_total >= hit:
			hit_item = key
			for i in range(results_array.size()):
				if results_array[i][0] == hit_item:
					results_array[i][1] += 1
					stack_flag = true
					break
			break

	if not stack_flag:
		results_array.append([hit_item, 1])
