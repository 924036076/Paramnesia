extends TextureRect

const item_base = preload("res://Control/ItemBase.tscn")
const item_base_plain = preload("res://Control/ItemBasePlain.tscn")

const shadow_helmet = preload("res://GUI/Inventory/ShadowArmor/ShadowHelmet.tscn")
const shadow_chest = preload("res://GUI/Inventory/ShadowArmor/ShadowChest.tscn")
const shadow_gloves = preload("res://GUI/Inventory/ShadowArmor/ShadowGloves.tscn")
const shadow_legs = preload("res://GUI/Inventory/ShadowArmor/ShadowLegs.tscn")
const shadow_boots = preload("res://GUI/Inventory/ShadowArmor/ShadowBoots.tscn")

func redraw():
	Utility.delete_children(self)
	var helmet = shadow_helmet.instance()
	var chest = shadow_chest.instance()
	var gloves = shadow_gloves.instance()
	var legs = shadow_legs.instance()
	var boots = shadow_boots.instance()
	
	helmet.rect_position = Vector2(7, 12)
	gloves.rect_position = Vector2(76, 12)
	chest.rect_position = Vector2(7, 43)
	legs.rect_position = Vector2(76, 43)
	boots.rect_position = Vector2(42, 77)
	
	add_child(helmet)
	add_child(gloves)
	add_child(chest)
	add_child(legs)
	add_child(boots)
	
	for i in range(40, 45):
		var item = PlayerData.inventory[i]
		if item[0] != null:
			var base = item_base.instance()
			if ItemDictionary.get_item(item[0])["stack"] == 1:
				base = item_base_plain.instance()
			else:
				base.value = item[1]
			base.texture = load(ItemDictionary.get_item(item[0])["icon"])
			match i:
				40:
					base.rect_position = Vector2(7, 12)
					helmet.queue_free()
				41:
					base.rect_position = Vector2(76, 12)
					gloves.queue_free()
				42:
					base.rect_position = Vector2(7, 43)
					chest.queue_free()
				43:
					base.rect_position = Vector2(76, 43)
					legs.queue_free()
				44:
					base.rect_position = Vector2(42, 77)
					boots.queue_free()
			add_child(base)

func update_selector(cursor_pos_passed, selector):
	var cursor_pos = cursor_pos_passed - rect_position
	var box_centers = [Vector2(14, 19), Vector2(83, 19), Vector2(14, 50), Vector2(83, 50), Vector2(49, 84)]
	var smallest_distance = cursor_pos.distance_to(box_centers[0])
	var selected_box = 0
	for center in box_centers:
		if cursor_pos.distance_to(center) < smallest_distance:
			smallest_distance = cursor_pos.distance_to(center)
			selected_box = box_centers.find(center)
	if smallest_distance > 18:
		selector.visible = false
		return null
	else:
		match selected_box:
			0:
				selector.rect_position = rect_position + Vector2(3, 8)
				return 40
			1:
				selector.rect_position = rect_position + Vector2(72, 8)
				return 41
			2:
				selector.rect_position = rect_position + Vector2(3, 39)
				return 42
			3:
				selector.rect_position = rect_position + Vector2(72, 39)
				return 43
			4:
				selector.rect_position = rect_position + Vector2(38, 73)
				return 44
