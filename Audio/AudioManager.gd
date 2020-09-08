extends Node

onready var music_player = get_node("Music/MusicPlayer")
onready var ui_sfx_player = get_node("UISFX/SFXPlayer")

var ui_sfx_volume = 0.7 setget set_ui_sfx_volume
var music_volume = 0.05 setget set_music_volume

var button_sound_effect = load("res://Audio/zapsplat_multimedia_button_click_fast_plastic_49161.wav")
var music = load("res://Audio/CCX Ambient Piece - Final.wav")

var muted = false setget set_mute
var master_volume = 0.5 setget set_master_volume

func _ready():
	set_ui_sfx_volume(ui_sfx_volume)
	set_music_volume(music_volume)
	set_master_volume(master_volume)
	play_music(music)

func play_music(music_file):
	music_player.stream = music_file
	music_player.play()

func play_ui_sfx(sound_effect):
	ui_sfx_player.stream = sound_effect
	ui_sfx_player.play()

func set_ui_sfx_volume(volume):
	ui_sfx_volume = volume
	ui_sfx_player.volume_db = linear2db(volume)

func set_music_volume(volume):
	music_volume = volume
	music_player.volume_db = linear2db(volume)

func click_button():
	play_ui_sfx(button_sound_effect)

func set_mute(value):
	muted = value
	if muted:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(0))
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(master_volume))

func set_master_volume(volume):
	master_volume = volume
	if !muted:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(volume))
