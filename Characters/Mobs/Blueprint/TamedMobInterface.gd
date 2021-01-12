extends Control

onready var name_input = get_node("NameChange/LineEdit")
onready var name_change = get_node("NameChange")

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

var mob = null

func _ready():
	if mob.given_name == "":
		get_node("Name").text = mob.SPECIES
	else:
		get_node("Name").text = mob.given_name
	get_node("Species").text = mob.SPECIES + " - Lvl " + str(mob.level)
	get_node("Sprite").texture = load(mob.idle_animation)
	get_node("AnimationPlayer").play("Idle")
	match mob.follow_mode:
		FOLLOW:
			get_node("FollowButton").text = "Follow"
		STAY:
			get_node("FollowButton").text = "Stay"
		WANDER:
			get_node("FollowButton").text = "Wander"
	match mob.stance:
		PASSIVE:
			get_node("StanceButton").text = "Passive"
		FLEE:
			get_node("StanceButton").text = "Flee"
		NEUTRAL:
			get_node("StanceButton").text = "Neutral"
		AGGRESSIVE:
			get_node("StanceButton").text = "Aggressive"

func _on_FollowButton_pressed():
	mob.follow_mode += 1
	if mob.follow_mode > WANDER:
		mob.follow_mode = FOLLOW
	match mob.follow_mode:
		FOLLOW:
			get_node("FollowButton").text = "Follow"
		STAY:
			get_node("FollowButton").text = "Stay"
		WANDER:
			get_node("FollowButton").text = "Wander"

func _on_ChangeNameButton_pressed():
	if mob.given_name == "":
		name_input.placeholder_text = mob.SPECIES
	else:
		name_input.placeholder_text = mob.given_name
	name_input.text = ""
	name_change.visible = true
	name_input.grab_focus()

func _on_LineEdit_text_entered(new_text):
	mob.given_name = new_text
	if mob.given_name == "":
		get_node("Name").text = mob.SPECIES
	else:
		get_node("Name").text = mob.given_name
	name_change.visible = false

func _on_TamedMobInterface_gui_input(event):
	if event is InputEventMouseButton:
		name_change.visible = false

func _on_DoneButton_pressed():
	mob.given_name = name_input.text
	if mob.given_name == "":
		get_node("Name").text = mob.SPECIES
	else:
		get_node("Name").text = mob.given_name
	name_change.visible = false

func _on_StanceButton_pressed():
	mob.stance += 1
	if mob.stance > AGGRESSIVE or (not mob.CAN_ATTACK and mob.stance > FLEE):
		mob.stance = PASSIVE
	match mob.stance:
		PASSIVE:
			get_node("StanceButton").text = "Passive"
		FLEE:
			get_node("StanceButton").text = "Flee"
		NEUTRAL:
			get_node("StanceButton").text = "Neutral"
		AGGRESSIVE:
			get_node("StanceButton").text = "Aggressive"
