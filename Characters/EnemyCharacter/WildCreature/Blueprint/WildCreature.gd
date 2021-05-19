extends EnemyCharacter

class_name WildCreature

enum {
	PASSIVE,
	NEUTRAL,
	AGGRESSIVE
}

enum {
	WALK,
	IDLE,
	ATTACK
}

export var CAN_TAME: bool = false
export var WANDER_RANGE: int = 100
export var FLEE_FROM_PREDATORS: bool = false
export var stance = PASSIVE
export var AGRO_TIME: float = 3.0
export var ATTACK_RANGE: int = 30
export var ATTACK_COOLDOWN: float = 1.0

var state = WALK
var agro: bool = false
var ready_to_attack: bool = true

func state_logic(delta):
	match state:
		WALK:
			walk(delta)
		IDLE:
			idle()
		ATTACK:
			attack()

func walk(delta):
	if agro:
		running = true
		if not is_pathing:
			if is_instance_valid(last_damage_source):
				path_target = last_damage_source.global_position
				is_pathing = start_path(path_target)
				get_node("AgroTimer").start(AGRO_TIME)
			else:
				var enemies = get_node("ViewDistance").get_overlapping_bodies()
				if enemies.size() < 1:
					agro = false
				else:
					for n in enemies:
						if n.is_in_group("Friendly") or (n.is_in_group("Enemy") and n.SPECIES != SPECIES):
							last_damage_source = n
					if is_instance_valid(last_damage_source):
						path_target = last_damage_source.global_position
						is_pathing = start_path(path_target)
						get_node("AgroTimer").start(AGRO_TIME)
					else:
						agro = false
		if agro:
			if self.global_position.distance_to(last_damage_source.global_position) < ATTACK_RANGE:
				state = ATTACK
	else:
		if not is_pathing:
			if randi() % 2 == 1:
				path_target = self.global_position + Vector2(rand_range(-WANDER_RANGE, WANDER_RANGE), rand_range(-WANDER_RANGE, WANDER_RANGE))
				is_pathing = start_path(path_target)
			if not is_pathing:
				state = IDLE
				get_node("WanderTimer").start()
	if is_pathing:
		follow_current_path(delta)
	if running:
		animation_state.travel("Run")
	else:
		animation_state.travel("Walk")

func idle():
	animation_state.travel("Idle")
	if agro:
		state = WALK

func attack():
	if ready_to_attack:
		ready_to_attack = false
		print("attack")
		get_node("AttackCooldown").start(ATTACK_COOLDOWN)
		animation_state.travel("Attack")
	else:
		state = WALK

func flee_logic(delta):
	if not is_pathing:
		path_target = global_position - 32 * global_position.direction_to(last_damage_source.global_position) + Vector2(rand_range(-16, 16), rand_range(-16, 16))
		is_pathing = start_path(path_target)
	follow_current_path(delta)
	if FLEE_FROM_PREDATORS:
		for n in get_node("ViewDistance").get_overlapping_bodies():
			if n.is_in_group("Predator"):
				get_node("FleeTimer").start(3.0)

func _on_ViewDistance_body_entered(body):
	if not fleeing and FLEE_FROM_PREDATORS:
		if body.is_in_group("Predator"):
			last_damage_source = body
			fleeing = true
			is_pathing = false
			get_node("FleeTimer").start(3.0)
	elif stance == AGGRESSIVE and not agro:
		if body.is_in_group("Friendly") or (body.is_in_group("Enemy") and body.SPECIES != SPECIES):
			last_damage_source = body
			is_pathing = false
			agro = true

func _on_WanderTimer_timeout():
	state = WALK

func damage_taken(reference: Object):
	if not agro and stance == NEUTRAL:
		last_damage_source = reference
		fleeing = false
		agro = true
		is_pathing = false
		get_node("AgroTimer").start(AGRO_TIME)

func set_direction(direction: Vector2):
	animation_tree.set("parameters/Idle/blend_position", direction)
	animation_tree.set("parameters/Walk/blend_position", direction)
	animation_tree.set("parameters/Run/blend_position", direction)
	if stance == NEUTRAL or stance == AGGRESSIVE:
		animation_tree.set("parameters/Attack/blend_position", direction)

func _on_AgroTimer_timeout():
	agro = false

func _on_AttackCooldown_timeout():
	ready_to_attack = true
