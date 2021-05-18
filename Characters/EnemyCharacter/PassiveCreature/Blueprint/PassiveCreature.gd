extends EnemyCharacter

enum {
	WALK,
	IDLE
}

export var WANDER_RANGE: int = 100

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
