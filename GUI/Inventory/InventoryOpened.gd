extends Control

const ground_item = preload("res://Control/GroundItem.tscn")

onready var inventory = get_node("Inventory")
onready var crafting = get_node("Crafting")

enum {
	LEFT,
	RIGHT,
	UP,
	DOWN
}

func _on_CraftingButton_pressed():
	if inventory.item_held == null:
		AudioManager.click_button()
		inventory.active = false
		inventory.visible = false
		crafting.active = true
		crafting.visible = true

func _on_InventoryButton_pressed():
	AudioManager.click_button()
	crafting.active = false
	crafting.visible = false
	inventory.active = true
	inventory.redraw()
	inventory.visible = true

func drop_items():
	if inventory.item_held != null:
		var item_box = ground_item.instance()
		item_box.item_id = inventory.item_held.get_meta("id")
		item_box.item_num = inventory.item_held.get_meta("num")
		item_box.position = get_tree().get_current_scene().get_node("GlobalYSort/Player").position
		var dir = get_tree().get_current_scene().get_node("GlobalYSort/Player").get_direction_facing()
		var drop_offset = Vector2(0, 0)
		if dir == LEFT:
			drop_offset = Vector2(-20, 0)
		elif dir == RIGHT:
			drop_offset = Vector2(20, 0)
		elif dir == UP:
			drop_offset = Vector2(0, -20)
		elif dir == DOWN:
			drop_offset = Vector2(0, 15)
		item_box.position += drop_offset
		get_tree().get_current_scene().get_node("GlobalYSort").add_child(item_box)
		inventory.item_held = null
