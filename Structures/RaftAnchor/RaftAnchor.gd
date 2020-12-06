extends StaticBody2D

onready var sprite = get_node("Sprite")

signal toggle_hitch

var has_focus: bool = false

func _ready():
	sprite.set_material(sprite.get_material().duplicate())
	sprite.get_material().set_shader_param("line_thickness", 0)

func _on_Area2D_mouse_entered():
	try_to_grab_focus()

func _on_Area2D_mouse_exited():
	if has_focus:
		has_focus = false
		Global.num_interacted_with = 0
	sprite.get_material().set_shader_param("line_thickness", 0)

func _on_Area2D_input_event(_viewport, _event, _shape_idx):
	try_to_grab_focus()
	if Input.is_action_just_pressed("inventory_alt") and has_focus:
		object_interacted_with()

func try_to_grab_focus():
	if Global.num_interacted_with < 1:
		has_focus = true
		Global.num_interacted_with = 1
		sprite.get_material().set_shader_param("line_thickness", 1)

func object_interacted_with():
	emit_signal("toggle_hitch")

func toggle_active(active):
	visible = active
	get_node("CollisionShape2D").disabled = not active
	get_node("InteractArea/CollisionShape2D").disabled = not active
