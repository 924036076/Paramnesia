extends KinematicBody2D

class_name PassiveMob

const floating_numbers = preload("res://Effects/DamageNumbers/FriendlyNumbers.tscn")

export var max_health: int = 100
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
onready var sprite = get_node("Sprite")
onready var hit_timer = get_node("HitEffect")

var health setget set_health
var running_speed = 2.5 * walking_speed
var dir = RIGHT
var state = WALK
var stay_scared: bool = false
var knockback: Vector2 = Vector2.ZERO

func _ready():
	health_bar.max_value = max_health
	health = max_health
	health_bar.value = health
	sprite.set_material(sprite.get_material().duplicate())

func _physics_process(delta):
	match state:
		WALK:
			walk(delta)
		IDLE:
			idle()
		RUN:
			run(delta)
	knockback = knockback.move_toward(Vector2.ZERO, delta * 200)
	knockback = move_and_slide(knockback)
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
	if area.get_parent().has_method("resolve_hit"):
		area.get_parent().resolve_hit()
	if hurtbox.invincible:
		return
	var damage = 0
	if area.get_parent().has_method("get_damage"):
		damage = area.get_parent().get_damage()
	if area.get_parent().has_method("get_knockback"):
		knockback = area.get_parent().get_knockback()
	sprite.get_material().set_shader_param("highlight", true)
	hit_timer.start()
	state = RUN
	animation_player.playback_speed = 2
	stay_scared = true
	scared_timer.start()
	hurtbox.start_invicibility(0.4)
	set_health(health - damage)
	
	var numbers = floating_numbers.instance()
	numbers.text = str(damage)
	add_child(numbers)
	
	hurtbox.start_invicibility(1)

func set_health(new_health):
	health = new_health
	health_bar.value = health
	health_bar.show()
	health_bar.get_node("HealthBarTimer").start(15)
	if health <= 0:
		dead()

func dead():
	var splatter = load("res://Effects/Disappear/Disappear.tscn").instance()
	add_child(splatter)
	set_physics_process(false)
	animation_player.stop()

func _on_Scared_timeout():
	stay_scared = false

func _on_HitEffect_timeout():
	sprite.get_material().set_shader_param("highlight", false)

func _on_HealthBarTimer_timeout():
	health_bar.hide()
