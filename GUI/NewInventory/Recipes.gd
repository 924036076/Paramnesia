extends Control

const item_base = preload("res://GUI/ObjectInventory/InventoryItem.tscn")
const item_background = preload("res://GUI/ObjectInventory/ItemBackground.tscn")

var item_size: int = 32
var buffer: int = 10

func redraw():
	Utility.delete_children(self)
	var x = 4
	var y = 4
	for i in range(10):
		for item in ItemDictionary.ITEMS:
			if ItemDictionary.get_item(item)["craftable"]:
				var panel = item_background.instance()
				panel.rect_position = Vector2(x - 4, y - 4)
				add_child(panel)
				
				var recipe = item_base.instance()
				recipe.get_node("TextureRect").texture = load(ItemDictionary.get_item(item)["icon"])
				recipe.rect_position = Vector2(x, y)
				add_child(recipe)
				rect_min_size.y = y + item_size + buffer - 3
				x += item_size + buffer
				if x + item_size + buffer - 4 > rect_size.x:
					x = 4
					y += item_size + buffer

func get_item_at_location(cursor_pos: Vector2):
	cursor_pos -= rect_global_position
	cursor_pos.y += get_parent().scroll_vertical
	var slot = int((cursor_pos.x + 0) / (item_size + buffer)) + int(cursor_pos.y / (item_size + buffer)) * int(rect_size.x / (item_size + buffer))
	return slot
