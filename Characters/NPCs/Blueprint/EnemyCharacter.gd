extends KinematicBody2D

class_name EnemyCharacter

onready var animation_player = get_node("AnimationPlayer")
onready var health_bar = get_node("HealthBar")
onready var hurtbox = get_node("Hurtbox")
onready var sprite = get_node("Sprite")
onready var hit_timer = get_node("HitEffect")
onready var animationPlayer = get_node("AnimationPlayer")
onready var animationTree = get_node("AnimationTree")
onready var animationState = animationTree.get("parameters/playback")
onready var focus = get_node("Focus")
onready var attack_timer = get_node("AttackCooldown")
onready var debug_text = get_node("DebugText")

enum {
	WANDER,
	PATH,
	GUARD
}

enum {
	WALK,
	ATTACK,
	IDLE
}

export var max_health: int = 100
export var MAX_SPEED: float = 50.0
export var ACCELERATION: float = 500.0
export var AGRO_RANGE: float = 200.0
export var LEAVE_AGRO_RANGE: float = 300.0
export var ATTACK_RANGE: float = 20.0
export var FOCUS_TIME: float = 2.0
export var ATTACK_COOLDOWN: float = 2.5

var health setget set_health
var MAX_WANDER_DISTANCE: float = 20.0
var dir = Vector2(1, 0)
var state = IDLE
export var goal = WANDER
var velocity = Vector2.ZERO
var spawn_location
var path_target = Vector2.ZERO
var agro = false
var can_attack = true
var nearest_enemy

func _ready():
	health_bar.max_value = max_health
	health = max_health
	health_bar.value = health
	focus.wait_time = FOCUS_TIME
	attack_timer.wait_time = ATTACK_COOLDOWN
	spawn_location = global_position
	sprite.set_material(sprite.get_material().duplicate())
	animationTree.active = true
	animationState.start("Walk")
	set_direction(dir)

func _physics_process(delta):
	set_direction(dir)
	if agro:
		agro_state()
		get_node("StateIndicator").frame = 2
	else:
		if goal == GUARD:
			get_node("StateIndicator").frame = 1
		else:
			get_node("StateIndicator").frame = 0
	match state:
		WALK:
			walk(delta)
		IDLE:
			idle()
		ATTACK:
			attack()
	check_for_enemies()
	update_debug_text()

func walk(delta):
	velocity = velocity.move_toward(dir * MAX_SPEED, ACCELERATION * delta)
	velocity = move_and_slide(velocity)
	if goal == GUARD or agro:
		animationState.travel("WalkWeapon")
	else:
		animationState.travel("Walk")

func agro_state():
	dir = global_position.direction_to(nearest_enemy.global_position)
	set_direction(dir)
	if global_position.distance_to(nearest_enemy.global_position) < ATTACK_RANGE:
		if can_attack:
			state = ATTACK
		else:
			state = IDLE
	else:
		state = WALK

func idle():
	if goal == GUARD or agro:
		animationState.travel("IdleWeapon")
	else:
		animationState.travel("Idle")

func attack():
	animationState.travel("Attack")

func choose_new_action():
	if goal == GUARD:
		if randi() % 2 == 0:
			state = WALK
		else:
			state = IDLE
		var dir_x = randi() % 10 - 5
		var dir_y = randi() % 10 - 5
		dir = Vector2(dir_x, dir_y).normalized()
		if global_position.distance_to(spawn_location) > MAX_WANDER_DISTANCE:
			dir = global_position.direction_to(spawn_location)
			state = WALK
	elif goal == WANDER:
		if randi() % 4 == 0:
			state = IDLE
		else:
			state = WALK
		var dir_x = randi() % 10 - 5
		var dir_y = randi() % 10 - 5
		dir = Vector2(dir_x, dir_y).normalized()
	elif goal == PATH:
		state = WALK
		dir = global_position.direction_to(path_target)

func check_for_enemies():
	agro = false
	var enemies = get_tree().get_nodes_in_group("FriendlyArmy")
	var smallest_distance = 1000
	for enemy in enemies:
		var enemy_distance = global_position.distance_to(enemy.global_position)
		if not agro:
			if enemy_distance < AGRO_RANGE:
				agro = true
				if enemy_distance < smallest_distance:
					nearest_enemy = enemy
					smallest_distance = enemy_distance
		else:
			if enemy_distance < LEAVE_AGRO_RANGE:
				agro = true
				if enemy_distance < smallest_distance:
					nearest_enemy = enemy
					smallest_distance = enemy_distance

func set_direction(direction):
	animationTree.set("parameters/Idle/blend_position", direction)
	animationTree.set("parameters/IdleWeapon/blend_position", direction)
	animationTree.set("parameters/Walk/blend_position", direction)
	animationTree.set("parameters/WalkWeapon/blend_position", direction)
	animationTree.set("parameters/Attack/blend_position", direction)

func dead():
	var splatter = load("res://Effects/Disappear/Disappear.tscn").instance()
	add_child(splatter)
	set_physics_process(false)
	animation_player.stop()

func _on_Hurtbox_area_entered(area):
	var damage = 0
	if area.get_parent().has_method("get_damage"):
		damage = area.get_parent().get_damage()
	if area.get_parent().has_method("resolve_hit"):
		area.get_parent().resolve_hit()
	sprite.get_material().set_shader_param("highlight", true)
	hit_timer.start()
	set_health(health - damage)
	hurtbox.start_invicibility(1)

func _on_HitEffect_timeout():
	sprite.get_material().set_shader_param("highlight", false)

func _on_Focus_timeout():
	if not agro:
		choose_new_action()

func set_health(new_health):
	health = new_health
	health_bar.value = health
	health_bar.show()
	health_bar.get_node("HealthBarTimer").start(15)
	if health <= 0:
		dead()

func update_debug_text():
	var debug_state = ""
	var debug_goal = ""
	
	match state:
		0:
			debug_state = "WALK"
		1:
			debug_state = "ATTACK"
		2:
			debug_state = "IDLE"

	match goal:
		0:
			debug_goal = "WANDER"
		1:
			debug_goal = "PATH"
		2:
			debug_goal = "GUARD"
	var text = "State: " + debug_state + "\nGoal: " + debug_goal + "\nAgro: " + str(agro)
	debug_text.text = text

func _on_HealthBarTimer_timeout():
	health_bar.hide()
