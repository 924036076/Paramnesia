extends Control

onready var blueprints = get_node("Blueprints")
onready var selector = get_node("Selector")
onready var panel = get_node("Panel")
onready var craft_button = get_node("CraftButton")
onready var error_message = get_node("ErrorMessage")

var hovering_over = null
var active = false
var locked_in = false
var shift = false

func _ready():
	redraw()

func _process(_delta):
	if active:
		var cursor_pos = get_global_mouse_position()
		if locked_in:
			panel.visible = true
			craft_button.visible = true
		else:
			panel.visible = false
			craft_button.visible = false
			update_selector(cursor_pos)
		if Input.is_action_just_pressed("inventory_main"):
			update_selector(cursor_pos)
			if hovering_over != null:
				locked_in = true
				panel.redraw(hovering_over, craft_button)
			elif craft_button.get_global_rect().has_point(cursor_pos):
				locked_in = true
				selector.visible = true
			else:
				locked_in = false
		elif Input.is_action_just_pressed("shift"):
			panel.shift = true
			shift = true
			panel.redraw_last()
		elif Input.is_action_just_released("shift"):
			panel.shift = false
			shift = false
			panel.redraw_last()
			

func update_selector(cursor_pos):
	if blueprints.get_global_rect().has_point(cursor_pos):
		selector.visible = true
		hovering_over = blueprints.update_selector(cursor_pos, selector)
	else:
		hovering_over = null
		selector.visible = false

func redraw():
	blueprints.redraw()

func _on_CraftButton_pressed():
	locked_in = true
	AudioManager.click_button()
	if panel.can_craft_current_item():
		var craft_controller = get_node("../../").return_controller()
		var result = craft_controller.add_to_queue(panel.selected_item_id)
		if shift:
			if panel.max_craftable_current_item() > 1:
				for _i in range(panel.max_craftable_current_item() - 1):
					result = craft_controller.add_to_queue(panel.selected_item_id)
		if result != "success":
			error_message.show_error(result)
	else:
		error_message.show_error("Blueprint not unlocked")
