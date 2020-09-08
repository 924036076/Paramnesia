extends TextureButton

onready var craft_text = get_node("Craft")
onready var craft_all_text = get_node("CraftAll")

func _input(_event):
	if Input.is_action_just_pressed("shift"):
		texture_normal = load("res://GUI/Inventory/Crafting/Panel/craft_all_button_up.png")
		texture_pressed = load("res://GUI/Inventory/Crafting/Panel/craft_all_button_down.png")
		craft_text.visible = false
		craft_all_text.visible = true
		rect_position = Vector2(56, 184)
		
	elif Input.is_action_just_released("shift"):
		texture_normal = load("res://GUI/Inventory/Crafting/Panel/craft_button_up.png")
		texture_pressed = load("res://GUI/Inventory/Crafting/Panel/craft_button_down.png")
		craft_text.visible = true
		craft_all_text.visible = false
		rect_position = Vector2(66, 184)
