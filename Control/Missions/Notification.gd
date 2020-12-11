extends Control

const sound = preload("res://Audio/notification_ding.wav")

onready var label = get_node("Label")
onready var nine_patch = get_node("NinePatchRect")
onready var tween = get_node("Tween")

var text = ""
var flag = false

func _ready():
	visible = false

func _on_Timer_timeout():
	queue_free()

func _on_Label_resized():
	if flag:
		nine_patch.rect_min_size.x = label.rect_size.x + 8
		tween.interpolate_property(self, "rect_position", Vector2(500, 0), Vector2(500 - nine_patch.rect_min_size.x, 0), 1.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		tween.start()
		visible = true
	else:
		flag = true

func _on_Delay_timeout():
	visible = true
	label.text = text
	AudioManager.play_ui_sfx(sound)
