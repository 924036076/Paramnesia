extends StaticBody2D

class_name InteractableObject

onready var sprite = get_node("Sprite")

func _ready():
	sprite.set_material(sprite.get_material().duplicate())
	sprite.get_material().set_shader_param("line_thickness", 0)
	extra_init()

func _on_InteractArea_mouse_entered():
	sprite.get_material().set_shader_param("line_thickness", 1)

func _on_InteractArea_mouse_exited():
	sprite.get_material().set_shader_param("line_thickness", 0)

func _on_InteractArea_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("inventory_alt"):
		interact()

func interact():
	pass

func extra_init():
	pass
