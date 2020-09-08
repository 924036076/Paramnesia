extends Area2D

onready var sprite = get_node("Sprite")
onready var item_sprite = get_node("ItemSprite")

var item_id
var item_num

func _ready():
	sprite.set_material(sprite.get_material().duplicate())

func _on_GroundItem_mouse_entered():
	sprite.get_material().set_shader_param("line_thickness", 1)
	update_item_sprite()
	item_sprite.texture = load(ItemDictionary.get_item(item_id)["icon"])
	item_sprite.visible = true

func _on_GroundItem_mouse_exited():
	sprite.get_material().set_shader_param("line_thickness", 0)
	item_sprite.visible = false

func _on_GroundItem_input_event(_viewport, _event, _shape_idx):
	update_item_sprite()
	if Input.is_action_just_pressed("inventory_alt"):
		PlayerData.add_to_inventory(0, item_id, item_num, true)
		queue_free()

func update_item_sprite():
	var cursor_pos = get_global_mouse_position()
	item_sprite.global_position = cursor_pos - Vector2(2, 2)
