extends TamedCreature

var riding: bool = false
var temp_flee_on_hit: bool
var temp_flee_on_low_health: bool

func extra_init():
	change_follow_mode(follow_mode)
	get_node("WanderTimer").wait_time = FOCUS_TIME
	get_node("Name").text = get_name()
	if not PLAYER_OWNED:
		CAN_INTERACT = false
	
	get_node("PlayerHair").texture = load("res://Player/Parts/hair/hair_" + str(PlayerData.hair) + ".png")
	get_node("PlayerOutfit").texture = load("res://Player/Parts/outfits/outfit_" + str(PlayerData.outfit) + ".png")
	
	get_node("PlayerBody").modulate = PlayerData.skin_color
	get_node("PlayerPupils").modulate = PlayerData.eye_color
	get_node("PlayerBrows").modulate = PlayerData.brow_color
	get_node("PlayerHair").modulate = PlayerData.hair_color

func state_logic(delta):
	if riding:
		running = true
		var input_vector = Vector2.ZERO
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		dir = input_vector.normalized()
		if input_vector != Vector2.ZERO:
			set_direction(dir)
			velocity = velocity.move_toward(dir * MAX_SPEED_RUNNING, ACCELERATION * delta)
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			if velocity.length() < Vector2(dir * MAX_SPEED_RUNNING * 0.5).length():
				animation_state.travel("Walk")
			else:
				animation_state.travel("Run")
		else:
			animation_state.travel("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		velocity = move_and_slide(velocity)
	else:
		match state:
			WALK:
				walk(delta)
			IDLE:
				idle(delta)
			ATTACK:
				attack()

func set_player_visible(vis: bool):
	get_node("PlayerBody").visible = vis
	get_node("PlayerOutfit").visible = vis
	get_node("PlayerEyes").visible = vis
	get_node("PlayerPupils").visible = vis
	get_node("PlayerBrows").visible = vis
	get_node("PlayerHair").visible = vis

func object_interacted_with():
	riding = not riding
	set_player_visible(riding)
	if riding:
		get_tree().get_current_scene().get_node("GlobalYSort/Player").start_riding(self)
		fleeing = false
		temp_flee_on_hit = FLEE_ON_HIT
		temp_flee_on_low_health = FLEE_ON_LOW_HEALTH
		FLEE_ON_HIT = false
		FLEE_ON_LOW_HEALTH = false
	else:
		get_tree().get_current_scene().get_node("GlobalYSort/Player").stop_riding()
		FLEE_ON_HIT = temp_flee_on_hit
		FLEE_ON_LOW_HEALTH = temp_flee_on_low_health

func dead():
	if riding:
		get_tree().get_current_scene().get_node("GlobalYSort/Player").stop_riding()
	
	if has_focus:
		has_focus = false
		Global.num_interacted_with = 0
	set_physics_process(false)
	
	var death_animation = disappear_effect.instance()
	add_child(death_animation)

func _on_PlayerBody_frame_changed():
	get_node("PlayerOutfit").frame = get_node("PlayerBody").frame
	get_node("PlayerEyes").frame = get_node("PlayerBody").frame
	get_node("PlayerPupils").frame = get_node("PlayerBody").frame
	get_node("PlayerBrows").frame = get_node("PlayerBody").frame
	get_node("PlayerHair").frame = get_node("PlayerBody").frame
