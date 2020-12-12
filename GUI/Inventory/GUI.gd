extends CanvasLayer

const inventory_open = preload("res://GUI/Inventory/InventoryOpened.tscn")
const missions_open = preload("res://GUI/Missions/Missions.tscn")

onready var controller = get_node("CraftController")
onready var queue = get_node("CraftController/Queue")
onready var hotbar = get_node("HotbarBounds")
onready var debug_overlay = get_node("DebugText")
onready var actual_hotbar = get_node("HotbarBounds/Hotbar")
onready var missions_button = get_node("MissionsButton")

var open = false
var inventory = null
var missions = null
var current_window = null setget set_current_window

signal inventory_changed(value)

func _process(_delta):
	var debug_text = str(Engine.get_frames_per_second()) + " fps"
	debug_text += "\nRAM Usage: " + String.humanize_size(OS.get_static_memory_usage())
	var x_coord = str(round(get_tree().get_current_scene().get_node("GlobalYSort/Player").global_position.x))
	var y_coord = str(round(get_tree().get_current_scene().get_node("GlobalYSort/Player").global_position.y))
	debug_text += "\nX: " + x_coord + " Y: " + y_coord
	debug_overlay.text = debug_text

func _input(_event):
	if Input.is_action_just_pressed("inventory_open"):
		if !open:
			open = true
			queue.visible = true
			hotbar.visible = false
			inventory = inventory_open.instance()
			add_child(inventory)
			emit_signal("inventory_changed", true)
		else:
			exit_inventory()

func hide_visible():
	get_node("HotbarBounds").visible = false

func show_visible():
	get_node("HotbarBounds").visible = true

func return_controller():
	return controller

func close_inventory():
	if not open:
		return true
	else:
		exit_inventory()
		return false

func exit_inventory():
	emit_signal("inventory_changed", false)
	open = false
	queue.visible = false
	hotbar.visible = true
	actual_hotbar.redraw()
	if inventory != null:
		inventory.drop_items()
		inventory.queue_free()
		inventory = null
	else:
		missions.queue_free()
		missions = null

func _on_MissionsButton_pressed():
	missions_button.texture_normal = load("res://GUI/Inventory/missions_indicator_seen.png")
	if not open:
		open = true
		hotbar.visible = false
		missions = missions_open.instance()
		add_child(missions)
	elif missions != null:
		missions.queue_free()
		missions = null
		open = false
		hotbar.visible = true
		actual_hotbar.redraw()

func new_mission():
	missions_button.texture_normal = load("res://GUI/Inventory/missions_indicator.png")

func set_current_window(window):
	if current_window != null:
		current_window.queue_free()
	current_window = window
	add_child(current_window)
