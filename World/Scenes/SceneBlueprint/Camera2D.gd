extends Camera2D

func _input(event):
	if Input.is_action_pressed("control"):
		if event.is_action_pressed("scroll_down"):
			zoom = zoom / 0.8
		elif event.is_action_pressed("scroll_up"):
			zoom = zoom * 0.8
	if Input.is_action_just_released("control"):
		zoom = Vector2(1, 1)
