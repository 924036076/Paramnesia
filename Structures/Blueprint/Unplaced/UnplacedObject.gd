extends StaticBody2D

onready var highlight = get_node("Highlight")
onready var sprite = get_node("Sprite")

var num_colliding: int = 0
var id: String = ""

func _ready():
	sprite.position.y = Structures.get_structure(id)["y_offset"]
	highlight.position.y = Structures.get_structure(id)["y_offset"]
	highlight.set_material(highlight.get_material().duplicate())
	highlight.get_material().set_shader_param("highlight_color", Color(0, 1, 0, 1))
	highlight.texture = load(Structures.get_structure(id)["sprite"])
	sprite.texture = load(Structures.get_structure(id)["sprite"])
	var collision = load(Structures.get_structure(id)["collision"]).instance()
	get_node("PlacementCollision").add_child(collision)

func _on_PlacementCollision_body_entered(_body):
	num_colliding += 1
	if num_colliding > 0:
		highlight.get_material().set_shader_param("highlight_color", Color(1, 0, 0, 1))

func _on_PlacementCollision_body_exited(_body):
	num_colliding -= 1
	if num_colliding < 1:
		highlight.get_material().set_shader_param("highlight_color", Color(0, 1, 0, 1))

func can_place():
	return num_colliding < 1

func place():
	var struct = load(Structures.get_structure(id)["instance"]).instance()
	struct.global_position = global_position
	get_parent().add_child(struct)
	queue_free()
