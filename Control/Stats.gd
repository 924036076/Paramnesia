extends Node

export var max_health = 0
onready var health = max_health setget set_health

export var damage = 0

signal no_health

func set_health(value):
	health = value
	if health <= 0:
		emit_signal("no_health")
