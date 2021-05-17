extends KinematicBody2D

onready var health_bar = get_node("HealthBar")

export var max_health: int = 100
export var damage: int = 10
export var MAX_SPEED: float = 50.0
export var ACCELERATION: float = 500.0
export var AGRO_RANGE: float = 200.0
export var LEAVE_AGRO_RANGE: float = 300.0
export var ATTACK_RANGE: float = 20.0
export var FOCUS_TIME: float = 2.0
export var ATTACK_COOLDOWN: float = 2.5
export var KNOCKBACK_STRENGTH: int = 200

var health: int setget set_health
var velocity: Vector2 = Vector2.ZERO
var knockback: Vector2 = Vector2.ZERO
var knockback_vector: Vector2 = Vector2.ZERO

func _ready():
	pass # Replace with function body.

func get_damage():
	return damage

func get_knockback():
	return knockback_vector * KNOCKBACK_STRENGTH

func set_health(new_health):
	health = new_health
	health_bar.value = health
	health_bar.show()
	health_bar.get_node("HealthBarTimer").start(15)
	if health <= 0:
		dead()

func dead():
	pass
