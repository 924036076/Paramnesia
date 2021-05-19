extends FriendlyCharacter

class_name TamedCreature

const INTERFACE = preload("res://Characters/Mobs/Blueprint/TamedMobInterface.tscn")

enum {
	WALK,
	IDLE,
	ATTACK
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

onready var wander_timer = get_node("WanderTimer")

export var FOCUS_TIME: float = 1.0
export var SPECIES: String = ""
export var ATTACK_RANGE: int = 20
export var ATTACK_COOLDOWN: float = 1.0
export var AGRO_TIME: float = 5.0
export var PLAYER_OWNED: bool = true

var stance = PASSIVE setget change_stance
var state = IDLE
var follow_mode = STAY setget change_follow_mode
var level: int = 1
var given_name: String = "" setget name_changed
var agro: bool = false
var ready_to_attack: bool = true

func extra_init():
	change_follow_mode(follow_mode)
	get_node("WanderTimer").wait_time = FOCUS_TIME
	get_node("Name").text = get_name()
	if not PLAYER_OWNED:
		CAN_INTERACT = false

func state_logic(delta):
	match state:
		WALK:
			walk(delta)
		IDLE:
			idle(delta)
		ATTACK:
			attack()

func walk(delta):
	if agro:
		if stance == AGGRESSIVE:
			check_for_enemies()
		if is_instance_valid(last_damage_source):
			path_target = last_damage_source.global_position
		else:
			agro = false
			return
		if not is_pathing:
			is_pathing = start_path(path_target)
			if not is_pathing:
				state = IDLE
		if self.global_position.distance_to(path_target) < ATTACK_RANGE:
			state = ATTACK
			running = true
		else:
			running = true
	else:
		match follow_mode:
			STAY:
				state = IDLE
			FOLLOW:
				path_target = get_tree().get_current_scene().get_node("GlobalYSort/Player").global_position
				if not is_pathing:
					is_pathing = start_path(path_target)
					if not is_pathing:
						state = IDLE
				var dist_to_player = self.global_position.distance_to(get_tree().get_current_scene().get_node("GlobalYSort/Player").global_position)
				if dist_to_player <= 32:
					state = IDLE
				elif dist_to_player > 64:
					running = true
			WANDER:
				if not is_pathing:
					if randi() % 2 == 1:
						path_target = self.global_position + Vector2(rand_range(-100, 100), rand_range(-100, 100))
						is_pathing = start_path(path_target)
					if not is_pathing:
						state = IDLE
						wander_timer.start()
	if is_pathing:
		follow_current_path(delta)
	if running:
		animation_state.travel("Run")
	else:
		animation_state.travel("Walk")

func idle(delta):
	animation_state.travel("Idle")
	
	if agro:
		path_target = last_damage_source.global_position
		is_pathing = start_path(path_target)
		if is_pathing:
			state = WALK
		return

	if follow_mode == FOLLOW and self.global_position.distance_to(get_tree().get_current_scene().get_node("GlobalYSort/Player").global_position) > 32:
		state = WALK
		path_target = get_tree().get_current_scene().get_node("GlobalYSort/Player").global_position
		is_pathing = start_path(path_target)
		if not is_pathing:
			state = IDLE
	
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)

func attack():
	if CAN_ATTACK and ready_to_attack:
		ready_to_attack = false
		get_node("AttackCooldown").start(ATTACK_COOLDOWN)
		animation_state.travel("Attack")
	else:
		state = WALK

func change_follow_mode(new_follow_mode):
	follow_mode = new_follow_mode
	is_pathing = false
	match follow_mode:
		STAY:
			state = IDLE
		WANDER:
			state = WALK
		FOLLOW:
			state = WALK

func change_stance(new_stance):
	stance = new_stance
	if stance == FLEE or stance == PASSIVE:
		agro = false
	elif stance == AGGRESSIVE:
		check_for_enemies()
	FLEE_ON_HIT = (stance == FLEE)

func name_changed(new_name: String):
	given_name = new_name
	get_node("Name").text = get_name()

func get_name() -> String:
	var n: String = ""
	if given_name == "":
		n = SPECIES
	else:
		n = given_name
	n += " (" + SPECIES + ") - Lvl " + str(level)
	return n

func object_interacted_with():
	var i = INTERFACE.instance()
	i.mob = self
	get_tree().get_current_scene().set_gui_window(i)

func mouse_entered():
	get_node("Name").visible = true

func mouse_exited():
	get_node("Name").visible = false

func _on_WanderTimer_timeout():
	path_target = self.global_position + Vector2(rand_range(-100, 100), rand_range(-100, 100))
	is_pathing = start_path(path_target)
	if is_pathing:
		state = WALK

func _on_ViewDistance_body_entered(body):
	if CAN_ATTACK and body.is_in_group("Enemy") and not agro:
		if stance == AGGRESSIVE:
			last_damage_source = body
			check_for_enemies()
			fleeing = false
			agro = true
			is_pathing = false

func check_for_enemies():
	var enemies = get_node("ViewDistance").get_overlapping_bodies()
	for n in enemies:
		if n.is_in_group("Enemy"):
			agro = true
			get_node("AgroTimer").start(AGRO_TIME)
			if is_instance_valid(last_damage_source):
				if n.global_position.distance_to(self.global_position) < last_damage_source.global_position.distance_to(self.global_position):
					last_damage_source = n
			else:
				last_damage_source = n

func damage_taken(reference: Object):
	if not agro:
		if stance == NEUTRAL or stance == AGGRESSIVE:
			last_damage_source = reference
			fleeing = false
			agro = true
			is_pathing = false
			get_node("AgroTimer").start(AGRO_TIME)

func set_direction(direction: Vector2):
	animation_tree.set("parameters/Idle/blend_position", direction)
	animation_tree.set("parameters/Walk/blend_position", direction)
	animation_tree.set("parameters/Run/blend_position", direction)
	if CAN_ATTACK:
		animation_tree.set("parameters/Attack/blend_position", direction)

func _on_AgroTimer_timeout():
	agro = false

func _on_AttackCooldown_timeout():
	ready_to_attack = true
