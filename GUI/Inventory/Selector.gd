extends TextureRect

func _ready():
	set_rect_position()

func set_rect_position():
	rect_position = Vector2(157 + PlayerData.holding * 25, 245)

func _input(event):
	if event.is_action_pressed("scroll_up"):
		PlayerData.holding += 1
		if PlayerData.holding > 7:
			PlayerData.holding  = -1
	if event.is_action_pressed("scroll_down"):
		PlayerData.holding -= 1
		if PlayerData.holding < -1:
			PlayerData.holding  = 7
	if event.is_action_pressed("select_1"):
		PlayerData.holding = -1
	elif event.is_action_pressed("select_2"):
		PlayerData.holding = 0
	elif event.is_action_pressed("select_3"):
		PlayerData.holding = 1
	elif event.is_action_pressed("select_4"):
		PlayerData.holding = 2
	elif event.is_action_pressed("select_5"):
		PlayerData.holding = 3
	elif event.is_action_pressed("select_6"):
		PlayerData.holding = 4
	elif event.is_action_pressed("select_7"):
		PlayerData.holding = 5
	elif event.is_action_pressed("select_8"):
		PlayerData.holding = 6
	elif event.is_action_pressed("select_9"):
		PlayerData.holding = 7
	set_rect_position()
	if PlayerData.holding == -1:
		rect_position = Vector2(155 + PlayerData.holding * 25, 245)
