extends TextureProgress

export var max_health = 0
onready var health = max_health setget set_health
onready var timer = get_node("Timer")

signal no_health

func _ready():
	max_value = max_health

func set_health(passed_value):
	health = passed_value
	value = health
	show()
	timer.start(15)
	if health <= 0:
		emit_signal("no_health")

func _on_Timer_timeout():
	hide()
