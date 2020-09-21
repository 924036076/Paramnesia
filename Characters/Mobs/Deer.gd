extends KinematicBody2D

onready var sprite = get_node("AnimatedSprite")

func _ready():
	sprite.playing = true

func _physics_process(delta):
	var velocity = Vector2(1, 0) * delta * 1000
	velocity = move_and_slide(velocity)
