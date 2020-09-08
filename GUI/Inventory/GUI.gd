extends CanvasLayer

const inventory_open = preload("res://GUI/Inventory/InventoryOpened.tscn")

onready var controller = get_node("CraftController")
onready var queue = get_node("CraftController/Queue")
onready var hotbar = get_node("HotbarBounds")
onready var debug_overlay = get_node("DebugText")
onready var actual_hotbar = get_node("HotbarBounds/Hotbar")

var open = false
var inventory = null

signal inventory_changed(value)

func _process(_delta):
	var debug_text = str(Engine.get_frames_per_second()) + " fps"
	debug_text += "\nRAM Usage: " + String.humanize_size(OS.get_static_memory_usage())
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
	inventory.drop_items()
	inventory.queue_free()
	inventory = null
