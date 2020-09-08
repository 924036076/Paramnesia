extends Control

const inventory_box = preload("res://GUI/Inventory/InventoryBox.tscn")
const item_base = preload("res://Control/ItemBase.tscn")

onready var queue_boxes = get_node("Queue")
onready var progress = get_node("CraftingProgress")
onready var current_item_icon = get_node("ItemIcon")
onready var current_item_count = get_node("ItemCount")

var queue = []
var currently_crafting = false
var crafting_time = 0

var item_craft_time = 7

signal queue_updated

func _ready():
	visible = false
	queue.resize(5)
	for i in range(5):
		queue[i] = [null, null]

func redraw():
	Utility.delete_children(queue_boxes)
	var x = 0
	var num_boxes = 0
	for i in range(queue_length()):
		var box = inventory_box.instance()
		box.rect_position = Vector2(x, 0)
		queue_boxes.add_child(box)
		
		var item = item_base.instance()
		item.texture = load(ItemDictionary.get_item(queue[i][0])["icon"])
		item.rect_position = Vector2(x + 6, 6)
		item.value = queue[i][1]
		item.get_node("Label").rect_scale = Vector2(0.8, 0.8)
		queue_boxes.add_child(item)
		
		num_boxes = num_boxes + 1
		x = x + 27
	if queue[0][0] != null:
		current_item_icon.texture = load(ItemDictionary.get_item(queue[0][0])["icon"])
		current_item_count.text = "x " + str(queue[0][1])
	emit_signal("queue_updated")

func _process(delta):
	if currently_crafting:
		crafting_time = crafting_time + delta
		progress.value = crafting_time * 100 / item_craft_time
		if crafting_time >= item_craft_time:
			var excess = PlayerData.add_to_inventory(0, queue[0][0], 1, true)
			if excess > 0:
				pass#drop items
			redraw()
			currently_crafting = false
			crafting_time = 0
			visible = false
			queue[0][1] = queue[0][1] - 1
			if queue[0][1] == 0:
				pop_queue_down()
			emit_signal("queue_updated")
	elif queue[0][0] != null:
		currently_crafting = attempt_to_craft(queue[0][0])
		if currently_crafting:
			redraw()
			visible = true
		else:
			pop_queue_down()

func pop_queue_down():
	for i in range(1, 5):
		queue[i - 1] = queue[i]
	queue[4] = [null, null]

func attempt_to_craft(item_id):
	var available = PlayerData.get_all_items()
	var needed = ItemDictionary.get_item(item_id)["recipe"]
	if has_all_materials(available, needed):
		PlayerData.remove_items(needed)
		return true
	else:
		return false

func add_to_queue(item_id):
	if materials_available(item_id):
		for item in queue:
			if item[0] == item_id:
				item[1] = item[1] + 1
				redraw()
				return "success"
		if queue_length() < 5:
			queue[queue_length()] = [item_id, 1]
			redraw()
			return "success"
		else:
			return "Queue is full"
	else:
		return "Missing materials"

func materials_available(item_id):
	var available = PlayerData.get_all_items()
	var queue_materials = get_all_materials()
	var needed = combine_inventories(queue_materials, ItemDictionary.get_item(item_id)["recipe"])
	return has_all_materials(available, needed)

func queue_length():
	for i in range(0, 5):
		if queue[i][0] == null:
			return i
	return 5

func get_all_materials():
	var mat_list = []
	for item in queue:
		if item[0] != null:
			for i in range(item[1]):
				if !(queue.find(item) == 0 and i == 0):
					var item_materials = ItemDictionary.get_item(item[0])["recipe"]
					mat_list = combine_inventories(mat_list, item_materials)
	return mat_list

func combine_inventories(inv_one, inv_two):
	var output = []
	for item in inv_one:
		output.append([item[0], item[1]])
	for item in inv_two:
		var in_array = false
		for i in output:
			if i[0] == item[0]:
				i[1] = i[1] + item[1]
				in_array = true
		if !in_array:
			output.append([item[0], item[1]])
	return output

func get_cancel_button_location():
	return Vector2(queue_length() * 19 + 50, 255)

func cancel_craft():
	if queue[0][0] != null:
		queue[0][1] = 1
	for i in range(1, 5):
		queue[i] = [null, null]
	redraw()

func has_all_materials(available, needed):
	for item in needed:
		var in_array = false
		for i in available:
			if i[0] == item[0]:
				in_array = true
				if i[1] < item[1]:
					return false
		if !in_array:
			return false
	return true
