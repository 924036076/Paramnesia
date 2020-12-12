extends KinematicBody2D

class_name TamedMob

const floating_numbers = preload("res://Effects/DamageNumbers/EnemyNumbers.tscn")
const interface = preload("res://Characters/Mobs/Blueprint/TamedMobInterface.tscn")

export var max_health: int = 100
export var MAX_SPEED: int = 5
export var ACCELERATION: int = 50
export var FOCUS_TIME: float = 1
export var SPECIES: String = ""

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
	NEUTRAL,
	AGGRESSIVE
}

var stance = PASSIVE
var follow_mode = STAY
var level: int = 1
var given_name: String = "" setget name_changed
var health setget set_health
var has_focus: bool = false
var dir: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var state = WALK

func _ready():
	animation_tree.active = true
	animation_state.start("Walk")
	
	random_direction()
	set_direction(dir)
	
	health_bar.max_value = max_health
	health = max_health
	health_bar.value = health
	
	focus_timer.wait_time = FOCUS_TIME

	sprite.set_material(sprite.get_material().duplicate())
	
	get_node("Name").text = get_name()

func _physics_process(delta):
	set_direction(dir)
	match state:
		WALK:
			walk(delta)

func walk(delta):
	velocity = velocity.move_toward(dir * MAX_SPEED, ACCELERATION * delta)
	velocity = move_and_slide(velocity)

func random_direction():
	var dir_x = randi() % 10 - 5
	var dir_y = randi() % 10 - 5
	dir = Vector2(dir_x, dir_y).normalized()

func _on_Hurtbox_area_entered(area):
	var damage = 0
	if area.get_parent().has_method("get_damage"):
		damage = area.get_parent().get_damage()
	if area.get_parent().has_method("resolve_hit"):
		area.get_parent().resolve_hit()
	sprite.get_material().set_shader_param("highlight", true)
	hit_timer.start()
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

func set_direction(direction):
	animation_tree.set("parameters/Walk/blend_position", direction)

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
	get_tree().get_current_scene().get_node("GUI").current_window = i

func _on_FocusTimer_timeout():
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
