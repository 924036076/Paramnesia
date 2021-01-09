extends Control

onready var wood = get_node("Wood")
onready var stone = get_node("Stone")
onready var fiber = get_node("Fiber")
onready var ingots = get_node("Ingots")
onready var obsidian = get_node("Obsidian")
onready var coins = get_node("Coins")

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
			max_points = 20
			
			wood.max_amount = 20
			stone.max_amount = 20
			fiber.max_amount = 20
			ingots.max_amount = 10
			obsidian.max_amount = 20
			coins.max_amount = 10
		NORMAL:
			max_points = 10
			
			wood.max_amount = 6
			stone.max_amount = 6
			fiber.max_amount = 10
			ingots.max_amount = 5
			obsidian.max_amount = 6
			coins.max_amount = 4
		HARD:
			max_points = 8
			
			wood.max_amount = 4
			stone.max_amount = 4
			fiber.max_amount = 4
			ingots.max_amount = 3
			obsidian.max_amount = 4
			coins.max_amount = 3
	
	available_points = max_points
	get_node("Points").text = "Resource Points Left: " + str(available_points) + "/" + str(max_points)

func set_available_points(new_amount):
	if available_points == 0 and new_amount > 0:
		for node in get_children():
			if node != get_node("Points"):
				node.set_plus_enabled()
	available_points = new_amount
	get_node("Points").text = "Resource Points Left: " + str(available_points) + "/" + str(max_points)
	if available_points == 0:
		for node in get_children():
			if node != get_node("Points"):
				node.set_plus_disabled()
