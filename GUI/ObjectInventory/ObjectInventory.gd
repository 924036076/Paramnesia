extends Control

const item_base = preload("res://GUI/ObjectInventory/InventoryItem.tscn")
const item_background = preload("res://GUI/ObjectInventory/ItemBackground.tscn")

var max_slots: int = 5
var inventory
var item_size: int = 32
var buffer: int = 10

func redraw():
	Utility.delete_children(self)
	var x = 0
	var y = 0
	for i in range(max_slots):
		var panel = item_background.instance()
		panel.rect_position = Vector2(x, y)
		if i == get_parent().object_hovering:
			panel.modulate = Color("#ebeaa4")
		add_child(panel)
		x += item_size + buffer
		if x + item_size + buffer > rect_size.x:
			x = 0
			y += item_size + buffer
	x = 4
	y = 4
	for slot in inventory:
		if slot[0] != null:
			var id = slot[0]
			var num = slot[1]
			var item = item_base.instance()
			item.get_node("TextureRect").texture = load(ItemDictionary.get_item(id)["icon"])
			if num > 0:
				item.get_node("Label").text = "x " + str(num)
			item.rect_position = Vector2(x, y)
			add_child(item)
			x += item_size + buffer
			if x + item_size + buffer - 4 > rect_size.x:
				x = 4
				y += item_size + buffer

func pop_item_at_pos(cursor_pos: Vector2):
	cursor_pos -= rect_global_position
	var slot = int(cursor_pos.x / (item_size + buffer)) + int(cursor_pos.y / (item_size + buffer)) * int(rect_size.x / (item_size + buffer))
	if slot > inventory.size() - 1:
		return null
	var item = inventory[slot]
	inventory.remove(slot)
	get_parent().object_inventory_updated()
	return item

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
	
	get_parent().object_inventory_updated()
	if num > 0:
		return [id, num]
	else:
		return null

func get_slot_at_pos(cursor_pos: Vector2):
	cursor_pos -= rect_global_position
	var slot = int(cursor_pos.x / (item_size + buffer)) + int(cursor_pos.y / (item_size + buffer)) * int(rect_size.x / (item_size + buffer))
	if slot > max_slots - 1:
		return null
	return slot

func insert_at_slot(slot: int, item: Array):
	if inventory.size() < max_slots:
		inventory.insert(slot, [item[0], item[1]])
	else:
		#drop items
		pass
	get_parent().object_inventory_updated()
