extends Panel

onready var recipes = get_node("ScrollContainer/Recipes")
onready var info = get_node("InfoPanel")

var selected = null

func _ready():
	redraw()

func _input(_event):
	if Input.is_action_just_pressed("inventory_main"):
		var cursor_pos = get_global_mouse_position()
		if get_node("ClickBounds").get_global_rect().has_point(cursor_pos):
			var item = recipes.get_item_at_location(cursor_pos)
			selected = item
		else:
			if not info.get_global_rect().has_point(cursor_pos):
				selected = null
	redraw()

func redraw():
	recipes.redraw()
	info.redraw()
