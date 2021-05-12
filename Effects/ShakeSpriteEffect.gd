extends Node2D

onready var sprite = get_parent().get_node("Sprite")
onready var initial_pos = sprite.position

export var amplitude: float = 1.0
export var frequency: float = 0.1
export var duration: float = 0.5

func _ready():
	get_node("Frequency").wait_time = frequency
	get_node("Duration").wait_time = duration

func start_shake():
	initial_pos = sprite.position
	get_node("Frequency").start()
	get_node("Duration").start()
	shake()

func shake():
	var offset = Vector2(rand_range(-amplitude, amplitude), rand_range(-amplitude, amplitude))
	var new_pos = initial_pos + offset
	get_node("Tween").interpolate_property(sprite, "position", sprite.position, new_pos, frequency, Tween.TRANS_LINEAR)
	get_node("Tween").start()

func _on_Frequency_timeout():
	shake()

func _on_Duration_timeout():
	reset()

func reset():
	sprite.position = initial_pos
	get_node("Frequency").stop()
	get_node("Duration").stop()
