extends Control

const item_base = preload("res://GUI/ObjectInventory/InventoryItem.tscn")
const item_background = preload("res://GUI/ObjectInventory/ItemBackground.tscn")

var item_size: int = 32
var buffer: int = 10

func redraw():
	Utility.delete_children(self)
	var x = -4
	var y = -4
	for _i in range(PlayerData.max_slots):
		var panel = item_background.instance()
		panel.rect_position = Vector2(x, y)
		add_child(panel)
		x += item_size + buffer
		if x + item_size + buffer > rect_size.x:
			x = -4
			y += item_size + buffer
	x = 0
	y = 0
	for slot in PlayerData.inventory:
		var id = slot[0]
		var num = slot[1]
		
		var item = item_base.instance()
		item.get_node("TextureRect").texture = load(ItemDictionary.get_item(id)["icon"])
		if num > 0:
			item.get_node("Label").text = "x " + str(num)
		item.rect_position = Vector2(x, y)
		add_child(item)
		x += item_size + buffer
		if x + item_size + buffer > rect_size.x:
			x = 0
			y += item_size + buffer

func pop_item_at_pos(cursor_pos):
	cursor_pos -= rect_global_position
	var slot = int(cursor_pos.x / (item_size + buffer)) + int(cursor_pos.y / (item_size + buffer)) * int(rect_size.x / (item_size + buffer))
	return PlayerData.pop_item_at_slot(slot)

func get_slot_at_pos(cursor_pos):
	cursor_pos -= rect_global_position
	var slot = int(cursor_pos.x / (item_size + buffer)) + int(cursor_pos.y / (item_size + buffer)) * int(rect_size.x / (item_size + buffer))
	return slot
