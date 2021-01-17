extends Panel

onready var selected = get_node("SelectedItem")
onready var options = get_node("Options")

func redraw():
	if get_parent().selected == null:
		options.visible  = true
		selected.visible = false
	else:
		options.visible = false
		selected.visible = true
