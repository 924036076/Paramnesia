extends KinematicBody2D

class_name TamedMob

const floating_numbers = preload("res://Effects/DamageNumbers/EnemyNumbers.tscn")
const interface = preload("res://Characters/Mobs/Blueprint/TamedMobInterface.tscn")

export var idle_animation: String
export var max_health: int = 100
export var MAX_SPEED: int = 5
export var ACCELERATION: int = 50
export var FOCUS_TIME: float = 1
export var SPECIES: String = ""
export var CAN_ATTACK: bool = true

onready var health_bar = get_node("HealthBar")
onready var hurtbox = get_node("Hurtbox")
onready var sprite = get_node("Sprite")
onready var hit_timer = get_node("HitEffect")
onready var focus_timer = get_node("FocusTimer")
onready var animation_player = get_node("AnimationPlayer")
onready var animation_tree = get_node("AnimationTree")
onready var animation_state = animation_tree.get("parameters/playback")

enum {
	WALK,
	IDLE
}

enum {
	FOLLOW,
	STAY,
	WANDER
}

enum {
	PASSIVE,
	FLEE,
	NEUTRAL,
	AGGRESSIVE
}

var stance = PASSIVE
var follow_mode = STAY setget change_follow_mode
var level: int = 1
var given_name: String = "" setget name_changed
var health setget set_health
var has_focus: bool = false
var dir: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var state = IDLE
var knockback: Vector2 = Vector2.ZERO
var flee: bool = false
var flee_dir: Vector2 = Vector2.ZERO

func _ready():
	initialize()

func initialize():
	animation_tree.active = true
	animation_state.start("Walk")
	
	change_follow_mode(follow_mode)
	
	health_bar.max_value = max_health
	health = max_health
	health_bar.value = health
	
	focus_timer.wait_time = FOCUS_TIME

	sprite.set_material(sprite.get_material().duplicate())
	
	get_node("Name").text = get_name()

func _physics_process(delta):
	if flee:
		set_direction(flee_dir)
		animation_state.travel("Walk")
		velocity = velocity.move_toward(flee_dir * MAX_SPEED * 5, ACCELERATION * 10 * delta)
		velocity = move_and_slide(velocity)
	else:
		set_direction(dir)
		match state:
			WALK:
				walk(delta)
			IDLE:
				idle()
	knockback = knockback.move_toward(Vector2.ZERO, delta * 300)
	knockback = move_and_slide(knockback)

func walk(delta):
	velocity = velocity.move_toward(dir * MAX_SPEED, ACCELERATION * delta)
	velocity = move_and_slide(velocity)
	animation_state.travel("Walk")

func idle():
	animation_state.travel("Idle")

func random_direction():
	if follow_mode == WANDER:
		if randi() % 3 == 0:
			state = IDLE
		else:
			state = WALK
	if state == WALK:
		var dir_x = randi() % 10 - 5
		var dir_y = randi() % 10 - 5
		dir = Vector2(dir_x, dir_y).normalized()
	elif state == IDLE:
		var dir_x = randi() % 2
		if dir_x == 0:
			dir = Vector2(-1, 0)
		else:
			dir = Vector2(1, 0)

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
	set_health(health - damage)
	
	var numbers = floating_numbers.instance()
	numbers.text = str(damage)
	add_child(numbers)
	
	if stance == FLEE:
		get_node("FleeTimer").start()
		flee_dir = global_position.direction_to(area.get_parent().global_position)
		flee_dir = -flee_dir
		flee = true
	
	hurtbox.start_invicibility(0.4)

func set_health(new_health):
	health = new_health
	health_bar.value = health
	health_bar.show()
	health_bar.get_node("HealthBarTimer").start(15)
	if health <= 0:
		dead()

func set_direction(direction):
	animation_tree.set("parameters/Walk/blend_position", direction)
	animation_tree.set("parameters/Idle/blend_position", direction)

func dead():
	var splatter = load("res://Effects/Disappear/Disappear.tscn").instance()
	add_child(splatter)
	set_physics_process(false)
	animation_player.stop()

func _on_HitEffect_timeout():
	sprite.get_material().set_shader_param("highlight", false)

func _on_HealthBarTimer_timeout():
	health_bar.hide()

func _on_InteractArea_mouse_entered():
	try_to_grab_focus()
	get_node("Name").visible = true

func _on_InteractArea_mouse_exited():
	if has_focus:
		has_focus = false
		Global.num_interacted_with = 0
	sprite.get_material().set_shader_param("line_thickness", 0)
	get_node("Name").visible = false

func _on_InteractArea_input_event(_viewport, _event, _shape_idx):
	try_to_grab_focus()
	if Input.is_action_just_pressed("inventory_alt") and has_focus:
		interacted_with()

func try_to_grab_focus():
	if Global.num_interacted_with < 1:
		has_focus = true
		Global.num_interacted_with = 1
		sprite.get_material().set_shader_param("line_thickness", 1)

func interacted_with():
	var i = interface.instance()
	i.mob = self
	get_tree().get_current_scene().set_gui_window(i)

func _on_FocusTimer_timeout():
	if not flee:
		random_direction()

func get_name():
	var n: String = ""
	if given_name == "":
		n = SPECIES
	else:
		n = given_name
	n += " (" + SPECIES + ") - Lvl " + str(level)
	return n

func name_changed(new_name):
	given_name = new_name
	get_node("Name").text = get_name()

func change_follow_mode(mode):
	follow_mode = mode
	match follow_mode:
		STAY:
			state = IDLE
		WANDER:
			state = WALK
		FOLLOW:
			state = WALK

func _on_FleeTimer_timeout():
	flee = false
