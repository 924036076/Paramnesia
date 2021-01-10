extends Control

var creature: String = ""
var empty: bool = false
var level: int = 1

func _ready():
	if not empty:
		get_node("Background/Creature").texture = load("res://Structures/Cage/Creatures/" + creature + ".png")
		get_node("Background/Name").text = creature + " - Lvl " + str(level)
	else:
		get_node("Background/ReleaseButton").disabled = true
