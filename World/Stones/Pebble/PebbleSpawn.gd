extends AreaSpawn

const Pebble = preload("res://World/Stones/Pebble/Pebble.tscn")

onready var color_rect = get_node("ColorRect")
var spawn_region = []
export var spawn_frequency = 0.0

func _ready():
	spawn_frequency = spawn_frequency / 1000
	spawn_region = [Vector2(color_rect.rect_position), Vector2(color_rect.rect_position + color_rect.rect_size)]
	color_rect.queue_free()

func spawn():
	spawn_items(Pebble, spawn_frequency, spawn_region)
