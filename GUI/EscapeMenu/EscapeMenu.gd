extends CanvasLayer

onready var settings = load("res://GUI/Settings/Settings.tscn")
var settings_open: bool = false
var update_settings_open: bool = false

func _ready():
	get_tree().get_current_scene().get_node("GUI").hide_visible()

func _input(event):
	if event is InputEventKey:
		if event.pressed and not event.echo:
			if event.scancode == KEY_ESCAPE and not settings_open:
				Global.block_escape = true
				exit_menu()
			if update_settings_open:
				settings_open = false
				update_settings_open = false

func _on_BackButton_pressed():
	exit_menu()

func exit_menu():
	get_tree().paused = false
	get_tree().get_current_scene().get_node("GUI").show_visible()
	queue_free()

#save world and exit to menu
func _on_ExitButton_pressed():
	var path: String = get_tree().get_current_scene().save_path
	Global.save_game(path)
	Global.switch_scene("MainMenu", false)
	exit_menu()

#open up settings menu
func _on_SettingsButton_pressed():
	var settings_menu = settings.instance()
	settings_menu.connect("settings_closed", self, "settings_close")
	get_tree().get_root().add_child(settings_menu)
	settings_open = true

func settings_close():
	update_settings_open = true
