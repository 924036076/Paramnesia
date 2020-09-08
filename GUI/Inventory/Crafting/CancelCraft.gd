extends TextureButton

var controller

func _ready():
	controller = get_node("../../").return_controller()
	controller.connect("queue_updated", self, "redraw")
	redraw()

func set_this_position():
	rect_global_position = controller.get_cancel_button_location()

func _on_CancelCraft_pressed():
	AudioManager.click_button()
	controller.cancel_craft()

func redraw():
	if controller.queue_length() > 0:
		visible = true
		set_this_position()
	else:
		visible = false
