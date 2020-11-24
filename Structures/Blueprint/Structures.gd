extends Node

const STRUCTURES = {
	"campfire": {
		"sprite": "res://Structures/Campfire/fire_base.png",
		"instance": "res://Structures/Campfire/Campfire.tscn",
		"collision": "res://Structures/Campfire/PlacementCollision.tscn",
		"y_offset": -4
	},
	"null": {
		"sprite": "null",
		"instance": "null"
	}
}

func get_structure(struct_id):
	if struct_id in STRUCTURES:
		return STRUCTURES[struct_id]
	else:
		return STRUCTURES["null"]
