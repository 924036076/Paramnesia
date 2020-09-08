extends StaticBody2D

class_name Structure

onready var highlight = get_node("Highlight")
onready var sprite = get_node("Sprite")

export var placed = false
var num_colliding = 0

func _ready():
	get_node("CollisionShape2D").disabled = true
	sprite.set_material(sprite.get_material().duplicate())
	sprite.get_material().set_shader_param("line_thickness", 0)
	highlight.set_material(highlight.get_material().duplicate())
	highlight.get_material().set_shader_param("highlight_color", Color(0, 1, 0, 1))
	set_process(false)
	if placed:
		place()

func _on_PlacementCollision_body_entered(_body):
	num_colliding += 1
	if num_colliding > 0:
		highlight.get_material().set_shader_param("highlight_color", Color(1, 0, 0, 1))

func _on_PlacementCollision_body_exited(_body):
	num_colliding -= 1
	if num_colliding < 1:
		highlight.get_material().set_shader_param("highlight_color", Color(0, 1, 0, 1))

func place():
	placed = true
	get_node("CollisionShape2D").disabled = false
	get_node("PlacementCollision/CollisionShape2D").disabled = true
	highlight.visible = false
	sprite.get_material().set_shader_param("line_thickness", 1)
	set_process(true)

func can_place():
	return num_colliding < 1

func _on_InteractArea_mouse_entered():
	if placed:
		sprite.get_material().set_shader_param("line_thickness", 1)

func _on_InteractArea_mouse_exited():
	if placed:
		sprite.get_material().set_shader_param("line_thickness", 0)

func _on_InteractArea_input_event(_viewport, _event, _shape_idx):
	if placed:
		if Input.is_action_just_pressed("inventory_alt"):
			object_interacted_with()

func object_interacted_with():
	pass
