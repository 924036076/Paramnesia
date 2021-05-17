extends FriendlyCharacter

class_name TamedCreature

const INTERFACE = preload("res://Characters/Mobs/Blueprint/TamedMobInterface.tscn")

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

export var FOCUS_TIME: float = 1.0
export var SPECIES: String = ""
export var idle_animation: String # holdout from old tamedmob class, rework this later

var stance = PASSIVE
var state = IDLE
var follow_mode = STAY setget change_follow_mode
var level: int = 1
var given_name: String = "" setget name_changed

func extra_init():
	change_follow_mode(follow_mode)
	get_node("Name").text = get_name()

func state_logic(delta):
	match state:
		WALK:
			walk(delta)
		IDLE:
			idle()

func walk(delta):
	animation_state.travel("Walk")
	if fleeing:
		pass
	else:
		match follow_mode:
			STAY:
				state = IDLE
			FOLLOW:
				path_target = get_tree().get_current_scene().get_node("GlobalYSort/Player").global_position
				if not is_pathing:
					is_pathing = start_path(path_target)
			WANDER:
				if not is_pathing:
					path_target = self.global_position + Vector2(rand_range(-100, 100), rand_range(-100, 100))
					is_pathing = start_path(path_target)
					if not is_pathing:
						state = IDLE
	if is_pathing:
		follow_current_path(delta)

func idle():
	animation_state.travel("Idle")

func change_follow_mode(new_follow_mode):
	follow_mode = new_follow_mode
	match follow_mode:
		STAY:
			state = IDLE
		WANDER:
			state = WALK
		FOLLOW:
			state = WALK

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

