extends CanvasLayer

onready var AudioSettings = get_node("AudioSettings")
onready var VisualSettings = get_node("VisualSettings")
onready var ControlsSettings = get_node("ControlsSettings")

var button_sound_effect = load("res://Audio/zapsplat_multimedia_button_click_fast_plastic_49161.wav")

func _input(event):
	if event is InputEventKey:
		if event.pressed and not event.echo and event.scancode == KEY_ESCAPE:
			get_tree().paused = false
			Global.unpaused()
			queue_free()

func _ready():
	AudioSettings.visible = true
	ControlsSettings.visible = false
	VisualSettings.visible = false

func _on_VisualButton_pressed():
	AudioSettings.visible = false
	ControlsSettings.visible = false
	VisualSettings.visible = true
	AudioManager.click_button()

func _on_AudioButton_pressed():
	AudioSettings.visible = true
	ControlsSettings.visible = false
	VisualSettings.visible = false
	AudioManager.click_button()

func _on_ControlsButton_pressed():
	AudioSettings.visible = false
	ControlsSettings.visible = true
	VisualSettings.visible = false
	AudioManager.click_button()

func _on_ExitButton_pressed():
	AudioManager.click_button()
	get_tree().paused = false
	Global.unpaused()
	var path = get_tree().get_current_scene().save_path
	Global.save_game(path)
	Global.switch_scene("MainMenu", false)
	queue_free()
