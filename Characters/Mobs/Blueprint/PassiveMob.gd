extends KinematicBody2D

class_name PassiveMob

export var scared: bool = false
export var walking_speed: int = 25

enum {
	LEFT,
	RIGHT,
	UP,
	DOWN
}

enum {
	WALK,
	IDLE,
	RUN
}

onready var animation_player = get_node("AnimationPlayer")
onready var health_bar = get_node("ResourceIndicator")

var running_speed = 1.5 * walking_speed
var dir = RIGHT
var state = WALK

func _ready():
	health_bar.connect("no_health", self, "dead")

func _physics_process(delta):
	match state:
		WALK:
			walk(delta)
		IDLE:
			idle()
		RUN:
			run(delta)

func walk(delta):
	move(walking_speed, delta)

func idle():
	pass

func run(delta):
	move(running_speed, delta)

func move(speed, delta):
	var velocity
	speed *= 500
	match dir:
		LEFT:
			velocity = Vector2(-speed * delta, 0)
			animation_player.play("WalkLeft")
		RIGHT:
			velocity = Vector2(speed * delta, 0)
			animation_player.play("WalkRight")
		UP:
			velocity = Vector2(0, -speed * delta)
			animation_player.play("WalkUp")
		DOWN:
			velocity = Vector2(0, speed * delta)
			animation_player.play("WalkDown")
	velocity = move_and_slide(velocity)

func _on_NewState_timeout():
	if state != RUN:
		var random = randi() % 5
		if random < 4:
			dir = random
			state = WALK
		else:
			state = IDLE

func _on_Hurtbox_area_entered(area):
	health_bar.health -= 30

func dead():
	queue_free()
