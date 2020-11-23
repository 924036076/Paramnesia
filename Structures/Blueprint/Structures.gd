extends Node

func get_structure(structure_id):
	match structure_id:
		"campfire":
			return load("res://Structures/Campfire/Campfire.tscn").instance()
