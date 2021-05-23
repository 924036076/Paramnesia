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
export var ATTACK_COOLDOWN: float = 1.0
export var MAX_TAME: float = 50.0

var state = WALK
var agro: bool = false
var ready_to_attack: bool = true
var tame_amount: float = 0.0 setget set_tame_amount

func extra_init():
	get_node("Name").text = get_name()
	get_node("Name").visible = false
	
	get_node("TameBar").max_value = MAX_TAME
	get_node("TameBar").value = tame_amount
	get_node("TameBar").visible = false

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
		agro_logic()
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
		agro_logic()

func attack():
	if ready_to_attack:
		dir = self.global_position.direction_to(last_damage_source.global_position)
		set_direction(dir)
		ready_to_attack = false
		get_node("AttackCooldown").start(ATTACK_COOLDOWN)
		animation_state.travel("Attack")
	else:
		state = WALK

func agro_logic():
	if stance == AGGRESSIVE:
		search_for_enemies()
	# update the path with the target's latest position. If there is no target, leave agro
	if is_instance_valid(last_damage_source):
		path_target = last_damage_source.global_position
	else:
		agro = false
		return
	
	# attempt to path to the target and attack if in range
	if not is_pathing:
		is_pathing = start_path(path_target)
		if not is_pathing:
			state = IDLE
		else:
			state = WALK
	
	var enemies_in_range = get_node("AttackRange").get_overlapping_areas()
	for n in enemies_in_range:
		if n.get_parent() == last_damage_source:
			is_pathing = false
			state = ATTACK

func flee_logic(delta):
	if not is_pathing:
		path_target = global_position - 64 * global_position.direction_to(last_damage_source.global_position) + Vector2(rand_range(-16, 16), rand_range(-16, 16))
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

func damage_taken(damage_info: Dictionary):
	if not agro and (stance == NEUTRAL or stance == AGGRESSIVE):
		last_damage_source = damage_info["reference"]
		fleeing = false
		agro = true
		is_pathing = false
		get_node("AgroTimer").start(AGRO_TIME)
	if damage_info["type"] == "tame" and CAN_TAME:
		set_tame_amount(tame_amount + damage_info["damage"])

func set_direction(direction: Vector2):
	animation_tree.set("parameters/Idle/blend_position", direction)
	animation_tree.set("parameters/Walk/blend_position", direction)
	animation_tree.set("parameters/Run/blend_position", direction)
	if stance == NEUTRAL or stance == AGGRESSIVE:
		animation_tree.set("parameters/Attack/blend_position", direction)

func search_for_enemies():
	var enemies = get_node("ViewDistance").get_overlapping_bodies()
	for n in enemies:
		if n.is_in_group("Friendly") or (n.is_in_group("Enemy") and n.SPECIES != SPECIES):
			get_node("AgroTimer").start(AGRO_TIME)
			if is_instance_valid(last_damage_source):
				if n.global_position.distance_to(self.global_position) < last_damage_source.global_position.distance_to(self.global_position):
					last_damage_source = n
			else:
				last_damage_source = n

func _on_AgroTimer_timeout():
	agro = false
	var enemies = get_node("ViewDistance").get_overlapping_bodies()
	for n in enemies:
		if n.is_in_group("Friendly") or (n.is_in_group("Enemy") and n.SPECIES != SPECIES):
			agro = true

func _on_AttackCooldown_timeout():
	ready_to_attack = true

func set_tame_amount(new_amount):
	tame_amount = new_amount
	get_node("TameBar").visible = true
	tween.interpolate_property(get_node("TameBar"), "value", get_node("TameBar").value, tame_amount, 0.3, Tween.TRANS_LINEAR)
	tween.start()
	if tame_amount >= MAX_TAME:
		call_deferred("tame")

func tame():
	if has_focus:
		has_focus = false
		Global.num_interacted_with = 0
	
	var tamed_creature = load("res://Characters/Friendly/TamedCreature/" + SPECIES + "/" + SPECIES + ".tscn").instance()
	get_parent().add_child(tamed_creature)
	tamed_creature.global_position = self.global_position
	var particles = load("res://Effects/Particles/TameBurst.tscn").instance()
	get_parent().add_child(particles)
	particles.global_position = self.global_position
	queue_free()

func move(delta):
	var speed_multiplier: float = 1.0
	if CAN_TAME:
		speed_multiplier = 1 - 0.5 * (tame_amount / MAX_TAME)
	if running:
		velocity = velocity.move_toward(dir * MAX_SPEED_RUNNING * speed_multiplier, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(dir * MAX_SPEED * speed_multiplier, ACCELERATION * delta)
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)

func get_damage_info() -> Dictionary:
	var damage_amount = DAMAGE
	var knockback_amount = dir * KNOCKBACK_STRENGTH
	if CAN_TAME:
		damage_amount += tame_amount / MAX_TAME * DAMAGE * 5
		knockback_amount *= tame_amount / MAX_TAME * 3
	var damage_info: Dictionary = {
		"damage" : damage_amount,
		"reference" : self,
		"knockback" : knockback_amount,
		"type" : "normal"
	}
	return damage_info
