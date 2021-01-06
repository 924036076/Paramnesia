extends Control

onready var points = get_node("Points")

var key = "Supplies"

var max_points: int

func _ready():
	max_points = 20 - Global.difficulty * 5
	points.text = "Points Left: " + str(0) + "/" + str(max_points)

func back():
	Global.switch_scene("WorldSettings", false)

func _on_EmbarkButton_pressed():
	Global.switch_scene("Test1", false)

func _on_BackButton_pressed():
	back()
