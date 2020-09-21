extends Control

func _on_NewGame_pressed():
	Global.switch_scene("res://World/Scenes/SpawnScene.tscn", false)

func _on_LoadGame_pressed():
	Global.switch_scene("res://World/Scenes/SpawnScene.tscn", true)
