extends SpawnNode

const OakTree = preload("res://World/Trees/Oak/OakTree.tscn")

export var spawn_frequency = 0.66
var spawn_table = [[2, OakTree], [1, null]]

func _ready():
	spawn_table[0][0] = spawn_frequency
	spawn_table[1][0] = 1 - spawn_frequency
	get_node("ColorRect").queue_free()

func spawn():
	spawn_item(spawn_table)

func spawn_certain():
	spawn_item([[1, OakTree]])
