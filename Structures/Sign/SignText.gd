extends TextureRect

func _input(event):
	if event is InputEventMouse:
		if event is InputEventMouseMotion:
			return
		elif event is InputEventMouseButton and not event.pressed:
			return
	queue_free()
