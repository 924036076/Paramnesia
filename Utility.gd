extends Node2D

func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func try_to_grab_focus(node):
	if Global.num_interacted_with < 1:
		node.has_focus = true
		Global.num_interacted_with = 1
		node.sprite.get_material().set_shader_param("line_thickness", 1)
