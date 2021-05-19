extends EnemyCharacter

enum {
	WALK,
	IDLE
}

export var WANDER_RANGE: int = 100
export var FLEE_FROM_PREDATORS: bool = false

var state = WALK

func state_logic(delta):
	match state:
		WALK:
			walk(delta)
		IDLE:
			idle()

func walk(delta):
	animation_state.travel("Walk")
	if not is_pathing:
		path_target = self.global_position + Vector2(rand_range(-WANDER_RANGE, WANDER_RANGE), rand_range(-WANDER_RANGE, WANDER_RANGE))
		is_pathing = start_path(path_target)
		if not is_pathing:
			state = IDLE
			get_node("WanderTimer").start()
	if is_pathing:
		follow_current_path(delta)

func idle():
	animation_state.travel("Idle")

func choose_new_action():
	is_pathing = false
	if randi() % 4 == 1:
		state = IDLE
		get_node("WanderTimer").start()
	else:
		state = WALK

func flee_logic(delta):
	if not is_pathing:
		path_target = global_position - 32 * global_position.direction_to(last_damage_source.global_position) + Vector2(rand_range(-16, 16), rand_range(-16, 16))
		is_pathing = start_path(path_target)
	follow_current_path(delta)
	for n in get_node("ViewDistance").get_overlapping_bodies():
		if n.is_in_group("Predator"):
			get_node("FleeTimer").start(3.0)

func _on_ViewDistance_body_entered(body):
	if not fleeing and FLEE_FROM_PREDATORS:
		if body.is_in_group("Predator"):
			last_damage_source = body
			fleeing = true
			get_node("FleeTimer").start(3.0)
