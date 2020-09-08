extends Node

var filepath = "res://game.ini"
var config_file

var keybinds = {}

onready var settings_menu = load("res://GUI/Settings/Settings.tscn")
onready var console = load("res://GUI/Console/ConsoleTest.tscn")

var one_frame = true
var game_paused = false
var current_scene

func _ready():
	config_file = ConfigFile.new()
	if config_file.load(filepath) == OK:
		for key in config_file.get_section_keys("keybinds"):
			var key_value = config_file.get_value("keybinds", key)
			keybinds[key] = key_value
	else:
		print("game.ini is missing")
		get_tree().quit()
	
	current_scene = get_tree().get_current_scene()
	
	#set_game_binds()

func _input(event):
	if event is InputEventKey:
		if event.pressed and not event.echo and not game_paused and one_frame:
			if event.scancode == KEY_ESCAPE and get_tree().get_current_scene().get_node("GUI").close_inventory():
				get_tree().get_root().add_child(settings_menu.instance())
				get_tree().get_current_scene().get_node("GUI").hide_visible()
				paused()
			elif event.scancode == KEY_TAB:
				get_tree().get_root().add_child(console.instance())
				paused(false)
	if not one_frame:
		one_frame = true

func set_game_binds():
	for key in keybinds.keys():
		var value = keybinds[key]
		var action_list = InputMap.get_action_list(key)
		if !action_list.empty():
			InputMap.action_erase_event(key, action_list[0])
		
		var new_key = InputEventKey.new()
		new_key.set_scancode(value)
		InputMap.action_add_event(key, new_key)

func unpaused():
	game_paused = false
	one_frame = false
	get_tree().get_current_scene().get_node("GUI").show_visible()

func paused(hide_gui = true):
	game_paused = true
	if hide_gui:
		get_tree().get_current_scene().get_node("GUI").hide_visible()
	get_tree().paused = true

func switch_scene(path):
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)

func save_game():
	var save_game = File.new()
	save_game.open("res://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		# Call the node's save function.
		var node_data = node.call("save")
		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
	save_game.close()
