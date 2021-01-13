extends Node

export var max_health = 100
export var max_food = 100
export var max_water = 100
export var damage = 20

onready var health = max_health setget set_health
onready var food = max_food setget set_food
onready var water = max_water setget set_water

signal health_changed
signal water_changed
signal food_changed
signal inventory_updated
signal new_item_added

var inventory = []
var holding = -1
var level = 2

var max_slots: int = 24

func _ready():
	add_item(["wood", 500])
	add_item(["stone", 200])
	add_item(["stone_axe", 1])
# warning-ignore:return_value_discarded
	self.connect("inventory_updated", MissionController, "player_inventory_changed")

func pop_item_at_slot(slot: int):
	if slot > inventory.size() - 1:
		return null
	var item = inventory[slot]
	inventory.remove(slot)
	emit_signal("inventory_updated")
	return item

func get_item_at_slot(slot: int):
	if slot > inventory.size() - 1:
		return null
	var item = inventory[slot]
	return item

func insert_at_slot(slot: int, item: Array):
	if inventory.size() < max_slots:
		inventory.insert(slot, [item[0], item[1]])
	else:
		#drop items
		pass

func add_item(item: Array):
	var id = item[0]
	var num = item[1]
	var stack = ItemDictionary.get_item(id)["stack"]
	
	for i in range(max_slots):
		if i >= inventory.size():
			if num > stack:
				num -= stack
				inventory.append([id, stack])
			else:
				inventory.append([id, num])
				num = 0
				break
		if inventory[i][0] == id:
			if inventory[i][1] + num > stack:
				num -= stack - inventory[i][1]
				inventory[i][1] = stack
			else:
				inventory[i][1] = inventory[i][1] + num
				num = 0
				break
	
	if num > 0:
		return [id, num]
	else:
		return null

func set_primary(slot: int):
	if slot > inventory.size() - 1:
		return
	if slot != 0:
		var temp_item = inventory[0]
		inventory[0] = inventory[slot]
		inventory[slot] = temp_item
	emit_signal("inventory_updated")

func set_secondary(slot: int):
	if slot > inventory.size() - 1:
		return
	if slot != 1:
		var temp_item = inventory[1]
		inventory[1] = inventory[slot]
		inventory[slot] = temp_item
	emit_signal("inventory_updated")

func set_slot(slot: int, item: Array):
	if slot > inventory.size() - 1:
		return
	inventory[slot] = item
	emit_signal("inventory_updated")

func add_without_stacking(item: Array):
	if inventory.size() >= max_slots:
		return item
	inventory.append(item)
	return null

#old functions from before rework

func get_all_items():
	var item_list = []
	for item in inventory:
		if item[0] != null:
			var in_array = false
			for i in item_list:
				if i[0] != null:
					if i[0] == item[0]:
						i[1] = i[1] + item[1]
						in_array = true
			if !in_array:
				item_list.append([item[0], item[1]])
	return item_list

func add_list_to_inventory(start_index, item_list):
	for item in item_list:
		add_to_inventory(start_index, item[0], item[1])

func add_to_inventory(start_index, item_id, item_num, display_text = false):
	var num_left = item_num
	var stack = ItemDictionary.get_item(item_id)["stack"]
	for i in range(start_index, 40):
		if num_left == 0:
			break
		if !slot_has_item(i):
			if stack < num_left:
				add_to_slot(i, item_id, stack)
				num_left = num_left - stack
			else:
				add_to_slot(i, item_id, num_left)
				num_left = 0
		elif get_item_id(i) == item_id and get_item_num(i) < stack:
			if stack - get_item_num(i) < num_left:
				num_left = num_left - (stack - get_item_num(i))
				add_to_slot(i, item_id, stack)
			else:
				add_to_slot(i, item_id, get_item_num(i) + num_left)
				num_left = 0
	var item_name = item_id
	if ItemDictionary.get_item(item_id).has("name"):
		item_name = ItemDictionary.get_item(item_id)["name"]
	if display_text:
		emit_signal("new_item_added", item_name, item_num)
	return num_left

func can_pick():
	if holding == -1 or inventory[holding][0] == null or ItemDictionary.get_item(inventory[holding][0])["type"] == "resource":
		return true
	else:
		return false

func stack_on_slot(index, num):
	var total = get_item_num(index) + num
	var item_id = get_item_id(index)
	var stack = ItemDictionary.get_item(item_id)["stack"]
	if total > stack:
		add_to_slot(index, item_id, stack)
		return total - stack
	else:
		add_to_slot(index, item_id, total)
		return 0

func remove_items(item_list):
	for item in item_list:
		var amount_needed = item[1]
		for i in inventory:
			if i[0] == item[0]:
				if i[1] < amount_needed:
					amount_needed = amount_needed - i[1]
					i = [null, null]
				elif i[1] > amount_needed:
					i[1] = i[1] - amount_needed
					break
				else:
					i = [null, null]
					break
	emit_signal("inventory_updated")

func has_items(item_list):
	for item in item_list:
		var amount_needed = item[1]
		for i in inventory:
			if i[0] == item[0]:
				if i[1] < amount_needed:
					amount_needed = amount_needed - i[1]
				else:
					amount_needed = 0
					break
		if amount_needed > 0:
			return false
	return true

func remove_one(item):
	for i in inventory:
		if i[0] == item:
			i[1] -= 1
			if i[1] < 1:
				inventory[inventory.rfind(i)] = [null, null]
			emit_signal("inventory_updated")
			return
	emit_signal("inventory_updated")

func add_to_slot(hovering_over, item_id, item_num):
	inventory[hovering_over] = [item_id, item_num]
	emit_signal("inventory_updated")

func slot_has_item(index):
	return get_item_id(index) != null

func get_item_id(index):
	return inventory[index][0]

func get_item_num(index):
	return inventory[index][1]

func clear_slot(index):
	inventory[index] = [null, null]

func get_num_held(item_id):
	var count = 0
	for slot in inventory:
		if slot[0] == item_id:
			count = count + slot[1]
	return count

func get_item_held():
	if (holding == -1):
		return "hands"
	else:
		return inventory[holding][0]

func max_craftable(item_recipe):
	var num = 0
	var available_items = get_all_items()
	
	var out_of_items = false
	while (!out_of_items):
		for item in item_recipe:
			out_of_items = true
			var _amount_needed = item[1]
			for i in available_items:
				if i[0] == item[0]:
					if i[1] >= item[1]:
						i[1] = i[1] - item[1]
						out_of_items = false
					else:
						out_of_items = true
		num = num + 1
		if num > 100:
			break
	return num - 1

func remove_from_slot(slot, num):
	if inventory[slot][1] > num:
		inventory[slot][1] -= num
	else:
		clear_slot(slot)
	emit_signal("inventory_updated")

func set_health(value):
	health = clamp(value, 0, max_health)
	emit_signal("health_changed", value)

func set_food(value):
	food = clamp(value, 0, max_food)
	emit_signal("food_changed", value)

func set_water(value):
	water = clamp(value, 0, max_water)
	emit_signal("water_changed", value)
