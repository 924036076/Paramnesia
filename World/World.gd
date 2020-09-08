extends Node2D

onready var loading_bar = get_node("GUI/Loading")
onready var spawn_nodes = get_node("SpawnNodes")
var load_percent = 0
var loaded = false
var load_time = 0
var loading_started = false
var load_step = 0

var deer
var bat

func _ready():
	loading_bar.visible = true

func _process(delta):
	if !loaded:
		if !loading_started:
			load_time = load_time + delta
			if load_time - delta > 0:
				loading_started = true
		else:
			load_step = load_step + 1
			load_percent = load_percent + 0.20
			loading_bar.update_loading_bar(load_percent)
			match load_step:
				100:
					loading_bar.update_message("Spawning trees...")
					spawn_trees()
				200:
					loading_bar.update_message("Spawning ferns...")
					spawn_ferns()
				300:
					loading_bar.update_message("Spawning pebbles...")
					spawn_pebbles()
				400:
					loading_bar.update_message("Spawning sticks...")
					spawn_sticks()
				500:
					loading_bar.update_message("Finishing up")
					loaded = true
					var ambient_music = load("res://Audio/CCX Ambient Piece - Final.wav")
					AudioManager.play_music(ambient_music)

func spawn_ferns():
	for n in spawn_nodes.get_node("Ferns").get_children():
		n.spawn_certain()

func spawn_trees():
	for n in spawn_nodes.get_node("PineTrees").get_children():
		n.spawn_certain()
	for n in spawn_nodes.get_node("OakTrees").get_children():
		n.spawn_certain()

func spawn_pebbles():
	for n in spawn_nodes.get_node("Pebbles").get_children():
		n.spawn()

func spawn_sticks():
	for n in spawn_nodes.get_node("Sticks").get_children():
		n.spawn()

func spawn_mob(mob, x_coord, y_coord):
	if x_coord == -37 and y_coord == 37:
		x_coord = get_node("SpawnNodes/YSort/Player").position.x
		y_coord = get_node("SpawnNodes/YSort/Player").position.y
	var spawned_mob
	if mob == "deer":
		if deer == null:
			deer = load("res://Characters/Deer.tscn")
		spawned_mob = deer.instance()
	elif mob == "bat":
		if bat == null:
			bat = load("res://Characters/Bat.tscn")
		spawned_mob = bat.instance()
	if spawned_mob != null:
		spawned_mob.position = Vector2(x_coord, y_coord - 20)
		get_node("SpawnNodes/YSort").add_child(spawned_mob)
	
