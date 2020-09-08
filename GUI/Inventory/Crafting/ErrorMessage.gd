extends Label

onready var timer = get_node("Timer")

func show_error(message):
	text = message
	visible = true
	timer.start()

func _on_Timer_timeout():
	visible = false
