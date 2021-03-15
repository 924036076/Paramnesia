extends StaticBody2D

class_name Structure

onready var sprite = get_node("Sprite")

export var collision: bool = true
export var background: bool = false

var has_focus: bool = false
var can_interact: bool = true

func _ready():
	sprite.set_material(sprite.get_material().duplicate())
	sprite.get_material().set_shader_param("line_thickness", 0)
	get_node("CollisionShape2D").disabled = not collision
	if background:
		z_index = -5
	extra_init()

func _on_InteractArea_mouse_entered():
	if can_interact:
		try_to_grab_focus()

func _on_InteractArea_mouse_exited():
	if has_focus:
		has_focus = false
		Global.num_interacted_with = 0
	sprite.get_material().set_shader_param("line_thickness", 0)

func _on_InteractArea_input_event(_viewport, _event, _shape_idx):
	if can_interact:
		try_to_grab_focus()
		if Input.is_action_just_pressed("inventory_alt") and has_focus:
			object_interacted_with()

func try_to_grab_focus():
	if Global.num_interacted_with < 1:
		has_focus = true
		Global.num_interacted_with = 1
		sprite.get_material().set_shader_param("line_thickness", 1)

func save():
	var save_dict = {
		"filename" : get_filename(),
		"id" : "structure",
		"pos_x" : position.x,
		"pos_y" : position.y,
		}
	return save_dict

func load_from_save(data):
	global_position.x = data["pos_x"]
	global_position.y = data["pos_y"]

func object_interacted_with():
	pass

func extra_init():
	pass
