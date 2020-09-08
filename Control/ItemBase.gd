extends TextureRect

onready var label = get_node("Label")
var value setget set_label

func _ready():
	set_label(value)

func set_label(passed_value):
	value = passed_value
	if label != null:
		label.text = "x " + str(value)
