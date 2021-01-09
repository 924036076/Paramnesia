extends Control

onready var construction = get_node("ConstructionCounter")
onready var farming = get_node("FarmingCounter")
onready var trading = get_node("TradingCounter")
onready var foraging = get_node("ForagingCounter")

var max_points: int
var available_points: int setget set_available_points

enum {
	EASY,
	NORMAL,
	HARD
}

func _ready():
	match Global.difficulty:
		EASY:
			max_points = 2
		NORMAL:
			max_points = 1
		HARD:
			max_points = 1
	
	construction.max_amount = 1
	farming.max_amount = 1
	trading.max_amount = 1
	foraging.max_amount = 1
	
	available_points = max_points
	get_node("Points").text = "Specialist Points Left: " + str(available_points) + "/" + str(max_points)

func set_available_points(new_amount):
	if available_points == 0 and new_amount > 0:
		for node in get_children():
			if node != get_node("Points"):
				node.set_plus_enabled()
	available_points = new_amount
	get_node("Points").text = "Specialist Points Left: " + str(available_points) + "/" + str(max_points)
	if available_points == 0:
		for node in get_children():
			if node != get_node("Points"):
				node.set_plus_disabled()
