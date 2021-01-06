extends Control

onready var difficulty_button = get_node("DifficultyButton")

var key = "Embark"

enum {
	EASY,
	NORMAL,
	HARD
}

var difficulty = Global.difficulty

func _ready():
	update_difficulty_text()

func update_difficulty_text():
	match difficulty:
		EASY:
			difficulty_button.text = "Easy"
		NORMAL:
			difficulty_button.text = "Normal"
		HARD:
			difficulty_button.text = "Hard"

func back():
	Global.switch_scene("MainMenu", false)

func _on_BackButton_pressed():
	back()

func _on_NextButton_pressed():
	Global.switch_scene("Supplies", false)

func _on_DifficultyButton_pressed():
	difficulty += 1
	if difficulty > HARD:
		difficulty = EASY
	update_difficulty_text()
	Global.difficulty = difficulty
