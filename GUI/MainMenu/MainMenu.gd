extends Control

const settings = preload("res://GUI/Settings/Settings.tscn")

onready var settings_back = get_node("SettingsBackground")

var key = "MainMenu"

func _on_NewGame_pressed():
	Global.switch_scene("World1", false)

func _on_LoadGame_pressed():
	Global.switch_scene("World1", true)

func _on_Exit_pressed():
	get_tree().quit()

func _on_Settings_pressed():
	settings_back.visible = true
	var settings_menu = settings.instance()
	settings_menu.connect("settings_closed", self, "settings_close")
	get_tree().get_root().add_child(settings_menu)

func settings_close():
	settings_back.visible = false
