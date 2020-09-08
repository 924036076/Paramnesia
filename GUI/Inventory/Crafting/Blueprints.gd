extends TextureRect

const item_base = preload("res://Control/ItemBasePlain.tscn")
var num_blueprints = 0

func redraw():
	Utility.delete_children(self)
	var index = 0
	for item in ItemDictionary.ITEMS:
		if ItemDictionary.get_item(item)["craftable"]:
			var blueprint = item_base.instance()
			blueprint.rect_position = Vector2(index % 8 * 25 + 6, index / 8 * 25 + 6)
			blueprint.texture = load(ItemDictionary.get_item(item)["icon"])
			add_child(blueprint)
			
			if ItemDictionary.get_item(item)["level"] > PlayerData.level:
				blueprint.modulate.a = 0.6
				
			index = index + 1
	num_blueprints = index

func update_selector(cursor_pos_passed, selector):
	var cursor_pos = cursor_pos_passed - rect_position
	var grid_x = clamp(int(cursor_pos.x / 25), 0, 7)
	var grid_y = clamp(int(cursor_pos.y / 25), 0, 3)
	selector.rect_position = Vector2(grid_x * 25 + 2, grid_y * 25 + 2)
	selector.rect_position = selector.rect_position + rect_position
	var blueprint = 9 + grid_x + (8 * (grid_y - 1))
	if blueprint <= num_blueprints:
		return blueprint
	else:
		return null
