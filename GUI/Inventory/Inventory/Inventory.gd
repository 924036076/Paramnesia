extends Control

onready var grid = get_node("Grid")
onready var armor = get_node("Armor")
onready var hotbar  = get_node("Hotbar")
onready var selector = get_node("Selector")

const item_base = preload("res://Control/ItemBase.tscn")
const item_base_plain = preload("res://Control/ItemBasePlain.tscn")

var item_held = null
var hovering_over = null
var active = true

func _ready():
	PlayerData.connect("inventory_updated", self, "redraw")
	redraw()

func _process(_delta):
	if active:
		var cursor_pos = get_global_mouse_position()
		update_selector(cursor_pos)
		if item_held != null:
			item_held.rect_position = cursor_pos - Vector2(8, 8)
			if hovering_over != null:
				if Input.is_action_just_pressed("inventory_main"):
					release_item(cursor_pos)
				elif Input.is_action_just_pressed("inventory_alt"):
					release_one(cursor_pos)
		else:
			if hovering_over != null:
				if Input.is_action_pressed("shift"):
					if Input.is_action_just_pressed("inventory_main"):
						shift_item(cursor_pos)
				else:
					if Input.is_action_just_pressed("inventory_main"):
						grab_item(cursor_pos)
					elif Input.is_action_just_pressed("inventory_alt"):
						grab_half(cursor_pos)

func shift_item(cursor_pos):
	if PlayerData.slot_has_item(hovering_over):
		var item_id = PlayerData.get_item_id(hovering_over)
		var item_num = PlayerData.get_item_num(hovering_over)
		if ItemDictionary.get_item(item_id)["type"] == "armor":
			if ItemDictionary.get_item(item_id)["subtype"] == "helmet" and !PlayerData.slot_has_item(40):
				PlayerData.add_to_slot(40, item_id, item_num)
				PlayerData.clear_slot(hovering_over)
				redraw()
				return
			elif ItemDictionary.get_item(item_id)["subtype"] == "gloves" and !PlayerData.slot_has_item(41):
				PlayerData.add_to_slot(41, item_id, item_num)
				PlayerData.clear_slot(hovering_over)
				redraw()
				return
			elif ItemDictionary.get_item(item_id)["subtype"] == "chest" and !PlayerData.slot_has_item(42):
				PlayerData.add_to_slot(42, item_id, item_num)
				PlayerData.clear_slot(hovering_over)
				redraw()
				return
			elif ItemDictionary.get_item(item_id)["subtype"] == "legs" and !PlayerData.slot_has_item(43):
				PlayerData.add_to_slot(43, item_id, item_num)
				PlayerData.clear_slot(hovering_over)
				redraw()
				return
			elif ItemDictionary.get_item(item_id)["subtype"] == "boots" and !PlayerData.slot_has_item(44):
				PlayerData.add_to_slot(44, item_id, item_num)
				PlayerData.clear_slot(hovering_over)
				redraw()
				return
		var excess = 0
		if hovering_over < 8:
			PlayerData.clear_slot(hovering_over)
			excess = PlayerData.add_to_inventory(8, item_id, item_num)
		else:
			PlayerData.clear_slot(hovering_over)
			excess = PlayerData.add_to_inventory(0, item_id, item_num)
		if excess > 0:
			create_floating_item(item_id, excess, cursor_pos)

func grab_item(cursor_pos):
	if PlayerData.slot_has_item(hovering_over):
		var item_id = PlayerData.get_item_id(hovering_over)
		var item_num = PlayerData.get_item_num(hovering_over)
		create_floating_item(item_id, item_num, cursor_pos)
		PlayerData.clear_slot(hovering_over)
		redraw()

func grab_half(cursor_pos):
	if PlayerData.slot_has_item(hovering_over):
		var item_id = PlayerData.get_item_id(hovering_over)
		var item_num = PlayerData.get_item_num(hovering_over)
		var even = true
		if item_num % 2 != 0:
			even = false
			item_num = item_num - 1
		if item_num / 2 == 0:
			PlayerData.clear_slot(hovering_over)
		else:
			PlayerData.add_to_slot(hovering_over, item_id, item_num / 2)
		if !even:
			item_num = item_num / 2 + 1
		else:
			item_num = item_num / 2
		create_floating_item(item_id, item_num, cursor_pos)
		redraw()

func release_item(cursor_pos):
	if hovering_over < 40 or (ItemDictionary.get_item(item_held.get_meta("id"))["type"] == "armor" and (ItemDictionary.get_item(item_held.get_meta("id"))["subtype"] == "helmet" and hovering_over == 40) or (ItemDictionary.get_item(item_held.get_meta("id"))["subtype"] == "gloves" and hovering_over == 41) or (ItemDictionary.get_item(item_held.get_meta("id"))["subtype"] == "chest" and hovering_over == 42) or (ItemDictionary.get_item(item_held.get_meta("id"))["subtype"] == "legs" and hovering_over == 43) or (ItemDictionary.get_item(item_held.get_meta("id"))["subtype"] == "boots" and hovering_over == 44)):
		var item_id = item_held.get_meta("id")
		var item_num = item_held.get_meta("num")
		if PlayerData.slot_has_item(hovering_over):
			var temp_id = PlayerData.get_item_id(hovering_over)
			var temp_num = PlayerData.get_item_num(hovering_over)
			if temp_id == item_id:
				var excess = PlayerData.stack_on_slot(hovering_over, item_num)
				if excess > 0:
					if excess == item_num:
						PlayerData.add_to_slot(hovering_over, item_id, excess)
						create_floating_item(item_id, ItemDictionary.get_item(item_id)["stack"], cursor_pos)
					else:
						create_floating_item(item_id, excess, cursor_pos)
				else:
					item_held.queue_free()
					item_held = null
			else:
				PlayerData.add_to_slot(hovering_over, item_id, item_num)
				create_floating_item(temp_id, temp_num, cursor_pos)
		else:
			PlayerData.add_to_slot(hovering_over, item_id, item_num)
			item_held.queue_free()
			item_held = null
		redraw()

func release_one(_cursor_pos):
	if hovering_over < 40 or (ItemDictionary.get_item(item_held.get_meta("id"))["type"] == "armor" and (ItemDictionary.get_item(item_held.get_meta("id"))["subtype"] == "helmet" and hovering_over == 40) or (ItemDictionary.get_item(item_held.get_meta("id"))["subtype"] == "gloves" and hovering_over == 41) or (ItemDictionary.get_item(item_held.get_meta("id"))["subtype"] == "chest" and hovering_over == 42) or (ItemDictionary.get_item(item_held.get_meta("id"))["subtype"] == "legs" and hovering_over == 43) or (ItemDictionary.get_item(item_held.get_meta("id"))["subtype"] == "boots" and hovering_over == 44)):
		var item_id = item_held.get_meta("id")
		var item_num = item_held.get_meta("num")
		if !PlayerData.slot_has_item(hovering_over):
			PlayerData.add_to_slot(hovering_over, item_id, 1)
			item_num = item_num - 1
			if item_num == 0:
				item_held.queue_free()
				item_held = null
			else:
				item_held.set_meta("num", item_num)
				item_held.value = item_num
		elif PlayerData.get_item_id(hovering_over) == item_id:
			var num_in_slot = PlayerData.get_item_num(hovering_over)
			if num_in_slot < ItemDictionary.get_item(item_id)["stack"]:
				PlayerData.add_to_slot(hovering_over, item_id, num_in_slot + 1)
				item_num = item_num - 1
				if item_num == 0:
					item_held.queue_free()
					item_held = null
				else:
					item_held.set_meta("num", item_num)
					item_held.value = item_num
		elif item_num == 1:
			var temp_id = PlayerData.get_item_id(hovering_over)
			var temp_num = PlayerData.get_item_num(hovering_over)
			PlayerData.add_to_slot(hovering_over, item_id, 1)
			item_held.texture = load(ItemDictionary.get_item(temp_id)["icon"])
			item_held.value = temp_num
			item_held.set_meta("id", temp_id)
			item_held.set_meta("num", temp_num)
		redraw()

func create_floating_item(item_id, item_num, cursor_pos):
	if item_held != null:
		item_held.queue_free()
	item_held = null
	item_held = item_base.instance()
	if ItemDictionary.get_item(item_id)["stack"] == 1:
		item_held = item_base_plain.instance()
	else:
		item_held.value = item_num
	item_held.texture = load(ItemDictionary.get_item(item_id)["icon"])
	item_held.set_meta("id", item_id)
	item_held.set_meta("num", item_num)
	item_held.rect_position = cursor_pos - Vector2(8, 8)
	add_child(item_held)

func update_selector(cursor_pos):
	if get_container_under_mouse(cursor_pos) == null:
		selector.visible = false
		hovering_over = null
	else:
		selector.visible = true
		hovering_over = get_container_under_mouse(cursor_pos).update_selector(cursor_pos, selector)

func get_container_under_mouse(cursor_pos):
	var containers = [grid, armor, hotbar]
	for container in containers:
		if container.get_global_rect().has_point(cursor_pos):
			return container
	return null

func redraw():
	grid.redraw()
	armor.redraw()
	hotbar.redraw()
