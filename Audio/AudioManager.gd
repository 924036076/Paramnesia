extends Node

onready var music_player = get_node("Music/MusicPlayer")
onready var ui_sfx_player = get_node("UISFX/SFXPlayer")

var ui_sfx_volume = 0.7 setget set_ui_sfx_volume
var music_volume = 0.05 setget set_music_volume

var button_sound_effect = load("res://Audio/zapsplat_multimedia_button_click_fast_plastic_49161.wav")
var music = load("res://Audio/CCX Ambient Piece - Final.wav")

var muted = false setget set_mute
var master_volume = 0.5 setget set_master_volume

var default_values = {"ui": 0.7, "music": 0.05, "master": 0.5, "muted": false}

func _ready():
	load_settings_from_save(Global.audio)
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

func set_to_default():
	set_ui_sfx_volume(default_values["ui"])
	set_music_volume(default_values["music"])
	set_master_volume(default_values["master"])
	set_mute(default_values["muted"])

func load_settings_from_save(settings):
	var volume = settings.get("ui")
	if volume == null:
		volume = default_values["ui"]
	set_ui_sfx_volume(volume)
	
	volume = settings.get("music")
	if volume == null:
		volume = default_values["music"]
	set_music_volume(volume)
	
	volume = settings.get("master")
	if volume == null:
		volume = default_values["master"]
	set_master_volume(volume)
	
	var muted_value = settings.get("muted")
	if muted_value == null:
		muted_value = default_values["muted"]
	set_mute(muted_value)

func get_current_settings():
	return {"ui": ui_sfx_volume, "music": music_volume, "master": master_volume, "muted": muted}
