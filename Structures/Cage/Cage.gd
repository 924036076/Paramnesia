extends Structure

var creature: String

func extra_init():
	get_node("Creature").texture = load("res://Structures/Cage/" + creature + ".png")

func object_interacted_with():
	pass
