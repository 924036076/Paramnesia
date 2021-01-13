extends Control

onready var player = get_node("PlayerInventory")
onready var object = get_node("ObjectInventory")

export var num_object_slots: int = 5

var object_inventory = [["apple", 5], ["stone", 90], ["wood", 100]]
var item_held = null

func _ready():
	object.inventory = object_inventory
# warning-ignore:return_value_discarded
	PlayerData.connect("inventory_updated", self, "redraw")
	redraw()

func _input(_event):
	if Input.is_action_just_pressed("inventory_main"):
		var cursor_pos = get_global_mouse_position()
		if player.get_global_rect().has_point(cursor_pos):
			var slot = player.get_slot_at_pos(cursor_pos)
			var item = player.pop_item_at_pos(cursor_pos)
			if item != null:
				var remainder = object.add_item(item)
				if remainder != null:
					PlayerData.insert_at_slot(slot, remainder)
		elif object.get_global_rect().has_point(cursor_pos):
			var slot = object.get_slot_at_pos(cursor_pos)
			var item = object.pop_item_at_pos(cursor_pos)
			if item != null:
				var remainder = PlayerData.add_item(item)
				if remainder != null:
					object.insert_at_slot(slot, remainder)
		redraw()

func redraw():
	player.redraw()
	object.redraw()
