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
		Global.switch_scene("WorldSettings", false)
	else:
		_on_PrevButton_pressed()

func _on_EmbarkButton_pressed():
	Global.switch_scene("Test1", false)

func _on_NextButton_pressed():
	page += 1
	get_node("PrevButton").visible = true
	if page == 3:
		get_node("NextButton").visible = false
		get_node("EmbarkButton").visible = true
	match page:
		2:
			get_node("LivestockPage").visible = false
			get_node("ResourcePage").visible = true
		3:
			get_node("ResourcePage").visible = false
			get_node("SpecialistPage").visible = true

func _on_PrevButton_pressed():
	page -= 1
	get_node("NextButton").visible = true
	get_node("EmbarkButton").visible = false
	if page == 1:
		get_node("PrevButton").visible = false
	match page:
		1:
			get_node("ResourcePage").visible = false
			get_node("LivestockPage").visible = true
		2:
			get_node("SpecialistPage").visible = false
			get_node("ResourcePage").visible = true
