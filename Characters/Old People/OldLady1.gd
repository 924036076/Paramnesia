extends Character

const dead_scene = preload("res://Characters/Old People/Dead.tscn")

func dead():
	var dead = dead_scene.instance()
	dead.global_position = global_position + Vector2(0, -25)
	dead.get_node("Person").frame = 1
	match dir:
		LEFT:
			dead.get_node("Person").rotate(PI/2)
		RIGHT:
			dead.get_node("Person").rotate(-PI/2)
		DOWN:
			dead.get_node("Person").rotate(PI)
	get_parent().add_child(dead)
	queue_free()
