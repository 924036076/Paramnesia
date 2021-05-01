extends Control

var key = "Menu"

func back():
	Global.switch_scene("WorldSettings", false)

func _on_BackButton_pressed():
	back()

func _on_NextButton_pressed():
	Global.switch_scene("Supplies", false)
