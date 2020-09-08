extends Area2D

func _on_Teleport_body_entered(_body):
	get_parent().get_node("GlobalYSort/Player").global_position = get_node("EndPosition").global_position
