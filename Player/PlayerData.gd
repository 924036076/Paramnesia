extends Node

export var max_health = 100
export var max_food = 100
export var max_water = 100
export var damage = 20

signal coins_changed
signal day_changed
signal inventory_updated

var inventory = []
var holding = 0 setget set_holding
var level = 2
var coins: int = 0 setget set_coins
var max_slots: int = 24
var day: int = 1 setget set_day
var season: String = "Summer"
var time_of_day: float = 0

var hair: int = 1
var outfit: int = 1
var skin_color: Color = Color("#f0b577")
var hair_color: Color = Color("#8d3d21")
var brow_color: Color = Color("#261604")
var eye_color: Color = Color("#143eae")

func _ready():
	initialize()
# warning-ignore:return_value_discarded
	self.connect("inventory_updated", MissionController, "player_inventory_changed")

func initialize():
	coins = 0
	holding = 0
	level = 1
	inventory = []
	
	#debug items:
	add_item(["stone_axe", 1])
	add_item(["wood", 500])
	add_item(["stone", 200])
	add_item(["stone_axe", 1])

func _process(delta):
	time_of_day += delta
	if time_of_day > 10:
		set_day(day + 1)
		time_of_day = 0

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

func set_holding(value):
	holding = value
	emit_signal("inventory_updated")

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

func get_item_held():
	if holding > inventory.size() - 1:
		return null
	else:
		return inventory[holding]

func set_coins(value: int):
	coins = value
	emit_signal("coins_changed")

func set_day(value: int):
	day = value
	emit_signal("day_changed")
