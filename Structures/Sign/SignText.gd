extends Panel

onready var label = get_node("Label")
onready var timer = get_node("Timer")

var time: float = 0
var total: float = 1
var text = ""

signal freed

func _ready():
	label.text = text
	label.percent_visible = 0
	total = label.get_total_character_count() / 20 + 0.5

func _process(delta):
	time += delta
	label.percent_visible = time / total
	rect_size.x = label.rect_size.x * label.percent_visible + 6
	rect_position.x = -rect_size.x / (2 / rect_scale.x)
	label.rect_position.x = 4
	if label.percent_visible >= 1:
		set_process(false)
		timer.start()

func _on_Timer_timeout():
	emit_signal("freed")
	queue_free()
