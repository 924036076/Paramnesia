extends CanvasLayer

func _input(event):
	if event is InputEventKey:
		if event.pressed and not event.echo:
			if event.scancode == KEY_ESCAPE:
				Global.block_escape = true
				exit_menu()

func _on_BackButton_pressed():
	exit_menu()

func exit_menu():
	get_tree().paused = false
	queue_free()
