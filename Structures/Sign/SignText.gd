extends ColorRect

onready var label = get_node("Label")

var time: float = 0
var total: float = 1
var text = ""

func _ready():
	label.text = text
	label.percent_visible = 0
	total = label.get_total_character_count() / 20 + 0.5

func _process(delta):
	time += delta
	label.percent_visible = time / total
	rect_size.x = label.rect_size.x * label.percent_visible + 3
	rect_position.x = -rect_size.x / 4
	label.rect_position.x = 2
	if label.percent_visible >= 1:
		set_process(false)
