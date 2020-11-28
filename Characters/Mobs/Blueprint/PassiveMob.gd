extends KinematicBody2D

class_name PassiveMob

export var scared: bool = false
export var scare_radius: int = 100
export var walking_speed: int = 15

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
onready var health_bar = get_node("HealthBar")
onready var scared_timer = get_node("Scared")
onready var hurtbox = get_node("Hurtbox")

var running_speed = 2.5 * walking_speed
var dir = RIGHT
var state = WALK
var stay_scared: bool = false

func _physics_process(delta):
	match state:
		WALK:
			walk(delta)
		IDLE:
			idle()
		RUN:
			run(delta)
	check_for_predators()

func walk(delta):
	move(walking_speed, delta)

func idle():
	pass

func run(delta):
	move(running_speed, delta)
	if not stay_scared:
		state = WALK
		check_for_predators()
		if state == WALK:
			animation_player.playback_speed = 1

func move(speed, delta):
	var velocity
	speed *= 100
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

func check_for_predators():
	var scared_of = get_tree().get_nodes_in_group("Predator")
	for node in scared_of:
		if global_position.distance_to(node.global_position) < scare_radius:
			state = RUN
			animation_player.playback_speed = 2

func _on_NewState_timeout():
	if state != RUN:
		var random = randi() % 5
		if random < 4:
			dir = random
			state = WALK
		else:
			state = IDLE

func _on_Hurtbox_area_entered(area):
	if area.has_method("get_damage"):
		state = RUN
		animation_player.playback_speed = 2
		stay_scared = true
		scared_timer.start()
		health_bar.health -= area.get_damage()
		hurtbox.start_invicibility(1)

func dead():
	var splatter = load("res://Effects/Disappear/Disappear.tscn").instance()
	add_child(splatter)
	set_physics_process(false)
	animation_player.stop()

func _on_Scared_timeout():
	stay_scared = false
