extends Label

var time: float = 0
var total: float = 1

func _ready():
	percent_visible = 0
	total = get_total_character_count() / 20 + 0.5

func _process(delta):
	time += delta
	percent_visible = time / total
	if percent_visible >= 1:
		set_process(false)
