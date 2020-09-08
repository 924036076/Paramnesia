extends Area2D

class_name BackgroundInteract

onready var sprite = get_node("Sprite")

func _ready():
	sprite.set_material(sprite.get_material().duplicate())
	sprite.get_material().set_shader_param("line_thickness", 0)

func _on_BackgroundObjectInteract_mouse_entered():
	sprite.get_material().set_shader_param("line_thickness", 1)

func _on_BackgroundObjectInteract_mouse_exited():
	sprite.get_material().set_shader_param("line_thickness", 0)

func _on_BackgroundObjectInteract_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("inventory_alt"):
		interact()

func interact():
	pass
