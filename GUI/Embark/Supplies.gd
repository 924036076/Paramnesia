extends Control

var key = "Supplies"

func back():
	Global.switch_scene("WorldSettings", false)

func _on_EmbarkButton_pressed():
	Global.switch_scene("Test1", false)

func _on_BackButton_pressed():
	back()
