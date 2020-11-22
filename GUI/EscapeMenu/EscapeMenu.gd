extends CanvasLayer

onready var settings = load("res://GUI/Settings/Settings.tscn")

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

#save world and exit to menu
func _on_ExitButton_pressed():
	var path: String = get_tree().get_current_scene().save_path
	Global.save_game(path)
	Global.switch_scene("MainMenu", false)
	exit_menu()

#open up settings menu
func _on_SettingsButton_pressed():
	get_tree().get_root().add_child(settings.instance())
