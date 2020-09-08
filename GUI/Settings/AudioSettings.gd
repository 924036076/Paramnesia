extends Control

var button_sound_effect = load("res://Audio/zapsplat_multimedia_button_click_fast_plastic_49161.wav")

onready var interface_icon = get_node("Interface/SoundIcon")
onready var interface_slider = get_node("Interface/Slider")

onready var master_icon = get_node("Master/SoundIcon")
onready var master_slider = get_node("Master/Slider")

onready var music_icon = get_node("Music/SoundIcon")
onready var music_slider = get_node("Music/Slider")

onready var world_icon = get_node("World/SoundIcon")
onready var world_slider = get_node("World/Slider")

onready var mute_box = get_node("MuteButton")

var muted = false
var master_volume

func _ready():
	muted = AudioManager.muted
	get_node("MuteButton").pressed = muted
	
	master_slider.value = AudioManager.master_volume
	master_volume = AudioManager.master_volume
	update_icon(master_icon, master_volume)
	
	interface_slider.value = AudioManager.ui_sfx_volume
	update_icon(interface_icon, interface_slider.value)
	
	music_slider.value = AudioManager.music_volume
	update_icon(music_icon, music_slider.value)

func update_icon(audio_icon, value):
	if muted or value == 0:
		audio_icon.texture = load("res://GUI/Settings/SpeakerIcon/audio_icon_muted.png")
	elif value < 0.34:
		audio_icon.texture = load("res://GUI/Settings/SpeakerIcon/audio_icon_1.png")
	elif value < 0.64:
		audio_icon.texture = load("res://GUI/Settings/SpeakerIcon/audio_icon_2.png")
	else:
		audio_icon.texture = load("res://GUI/Settings/SpeakerIcon/audio_icon_3.png")

func _on_interface_volume_changed(value):
	AudioManager.ui_sfx_volume = value
	update_icon(interface_icon, value)

func _on_master_volume_changed(value):
	master_volume = value
	AudioManager.master_volume = value
	update_icon(master_icon, value)

func _on_music_volume_changed(value):
	AudioManager.music_volume = value
	update_icon(music_icon, value)

func _on_world_volume_changed(value):
	update_icon(world_icon, value)

func _on_MuteButton_toggled(button_pressed):
	muted = button_pressed
	AudioManager.muted = muted
	
	update_icon(master_icon, master_slider.value)
	update_icon(interface_icon, interface_slider.value)
	update_icon(music_icon, music_slider.value)
	update_icon(world_icon, world_slider.value)

func _on_ResetButton_pressed():
	if !muted:
		AudioManager.click_button()
	muted = false
	AudioManager.muted = false
	mute_box.pressed = false
	master_volume = 1
	master_slider.value = 0.5
	interface_slider.value = 0.7
	music_slider.value = 0.05
	world_slider.value = 1
	
