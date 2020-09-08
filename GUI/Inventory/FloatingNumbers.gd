extends Control

const label = preload("res://GUI/Inventory/FloatingItemNumber.tscn")

onready var label_1 = get_node("FloatingItemNumber")
onready var label_2 = get_node("FloatingItemNumber2")
onready var label_3 = get_node("FloatingItemNumber3")

var num_active_labels = 0
var frame_count = 0

func _ready():
	PlayerData.connect("new_item_added", self, "add_label")

func _process(_delta):
	if num_active_labels > 0:
		frame_count += 1
		if frame_count == 3:
			frame_count = 0
			rect_position = get_tree().get_current_scene().get_node("GlobalYSort/Player").get_global_transform_with_canvas().get_origin()
			rect_position = rect_position - Vector2(21, 47)

func add_label(name, count):
	var text = str(count) + "x " + name
	if num_active_labels == 0:
		label_1.reset(text, 1)
	elif num_active_labels == 1:
		label_2.reset(label_1.text, label_1.transparency)
		label_1.reset(text, 1)
	else:
		label_3.reset(label_2.text, label_2.transparency)
		label_2.reset(label_1.text, label_1.transparency)
		label_1.reset(text, 1)
	num_active_labels += 1

func _on_label_done():
	num_active_labels -= 1
