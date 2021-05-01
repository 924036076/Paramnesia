extends Control

onready var livestock = get_node("LivestockPage")
onready var resource = get_node("ResourcePage")
onready var specialist = get_node("SpecialistPage")

var key = "Menu"

var page: int = 1

func _input(_event):
	if page == 3 and (livestock.available_points + resource.available_points + specialist.available_points > 0):
		get_node("PointWarning").visible = true
	else:
		get_node("PointWarning").visible = false

func back():
	if page == 1:
		Global.switch_scene("CharacterCustomize", false)
	else:
		_on_PrevButton_pressed()

func _on_EmbarkButton_pressed():
	livestock.save_points()
	resource.save_points()
	specialist.save_points()
	PlayerData.initialize()
	Global.switch_scene("Test1", false)

func _on_NextButton_pressed():
	page += 1
	if page == 3:
		get_node("NextButton").visible = false
		get_node("EmbarkButton").visible = true
	match page:
		2:
			livestock.visible = false
			resource.visible = true
		3:
			resource.visible = false
			specialist.visible = true

func _on_PrevButton_pressed():
	if page == 1:
		back()
	page -= 1
	get_node("NextButton").visible = true
	get_node("EmbarkButton").visible = false
	match page:
		1:
			resource.visible = false
			livestock.visible = true
		2:
			specialist.visible = false
			resource.visible = true
