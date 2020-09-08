extends TextureRect

const item_base = preload("res://Control/ItemBase.tscn")
const item_base_plain = preload("res://Control/ItemBasePlain.tscn")

func redraw():
	Utility.delete_children(self)
	for i in range(0, 8):
		var item = PlayerData.inventory[i]
		if item[0] != null:
			var base = item_base.instance()
			if ItemDictionary.get_item(item[0])["stack"] == 1:
				base = item_base_plain.instance()
			else:
				base.value = item[1]
			base.texture = load(ItemDictionary.get_item(item[0])["icon"])
			base.rect_position = Vector2(25 * i + 6, 6)
			add_child(base)

func update_selector(cursor_pos_passed, selector):
	var cursor_pos = cursor_pos_passed - rect_position
	var grid_x = clamp(int(cursor_pos.x / 25), 0, 7)
	selector.rect_position = Vector2(grid_x * 25 + 2, 2)
	selector.rect_position = selector.rect_position + rect_position
	var item = grid_x
	return item
