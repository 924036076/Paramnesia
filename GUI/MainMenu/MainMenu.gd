extends Control

func _on_NewGame_pressed():
	Global.switch_scene("World1", false)

func _on_LoadGame_pressed():
	Global.switch_scene("World1", true)
