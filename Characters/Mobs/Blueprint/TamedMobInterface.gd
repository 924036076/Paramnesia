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
	NEUTRAL,
	AGGRESSIVE
}

var mob = null

func _ready():
	get_node("Title").text = mob.get_name()
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
	get_node("Title").text = mob.get_name()
	name_change.visible = false

func _on_TamedMobInterface_gui_input(event):
	if event is InputEventMouseButton:
		name_change.visible = false

func _on_DoneButton_pressed():
	mob.given_name = name_input.text
	get_node("Title").text = mob.get_name()
	name_change.visible = false

func _on_StanceButton_pressed():
	mob.stance += 1
	if mob.stance > AGGRESSIVE:
		mob.stance = PASSIVE
	match mob.stance:
		PASSIVE:
			get_node("StanceButton").text = "Passive"
		NEUTRAL:
			get_node("StanceButton").text = "Neutral"
		AGGRESSIVE:
			get_node("StanceButton").text = "Aggressive"
