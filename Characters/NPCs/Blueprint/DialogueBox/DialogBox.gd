extends Control

onready var label = get_node("Label")
onready var animation_player = get_node("AnimationPlayer")
onready var nine_patch = get_node("NinePatchRect")
onready var accept_button = get_node("AcceptButton")
onready var more_button = get_node("MoreButton")
onready var decline_button = get_node("DeclineButton")

var text = []
var page = 0

func _ready():
	label.text = text[0]
	nine_patch.rect_min_size.y = min(label.get_line_count(), label.max_lines_visible) * (label.get_line_height() + 3) + 6
	animation_player.playback_speed = 40.0 / label.text.length()
	animation_player.play("ShowText")
	rect_global_position.y -= nine_patch.rect_min_size.y
	accept_button.rect_position.y = nine_patch.rect_size.y - 1
	decline_button.rect_position.y = nine_patch.rect_size.y - 1
	more_button.rect_position.y = nine_patch.rect_size.y - 1

func _on_Timer_timeout():
	queue_free()

func _on_AcceptButton_pressed():
	queue_free()

func _on_MoreButton_pressed():
	page += 1
	more_button.visible = false
	if page < text.size():
		label.text = text[page]
		animation_player.playback_speed = 40.0 / label.text.length()
		animation_player.play("ShowText")
	else:
		accept_button.visible = true
		decline_button.visible = true

func animation_finished():
	if page + 1 < text.size():
		more_button.visible = true
	else:
		more_button.visible = false
		accept_button.visible = true
		decline_button.visible = true

func _on_DeclineButton_pressed():
	queue_free()
