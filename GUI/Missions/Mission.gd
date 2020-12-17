extends Control

const required_item = preload("res://GUI/Missions/ItemWithNumbers.tscn")

onready var expand_tween = get_node("ExpandTween")
onready var contract_tween = get_node("ContractTween")

var mission
var required: bool = false
var type: String

onready var background = get_node("Background")
onready var descr_label = get_node("Description")

func _ready():
	get_node("Title").text = mission["title"]
	descr_label.text = mission["description"]
	required = mission["required"]
	type = mission["type"]
	if type == "item":
		var item_list = mission["item_list"]
		var x = 60
		for item in item_list:
			var visual = required_item.instance()
			visual.get_node("TextureRect").texture = load(ItemDictionary.get_item(item[0])["icon"])
			visual.get_node("Label").text = "x " + str(item[1])
			get_node("ResourceMission").add_child(visual)
			visual.rect_position.x += x
			x += 40
	if required:
		get_node("DeleteButton").queue_free()

func _on_DeleteButton_pressed():
	if not required:
		MissionController.delete_mission(mission)
		queue_free()

func _on_ExpandButton_toggled(button_pressed):
	if button_pressed:
		var total_size_y = 24 + descr_label.get_line_count() * 10 + 8
		if type == "item":
			total_size_y += 14
		expand_tween.interpolate_property(background, "rect_size", Vector2(320, 24), Vector2(320, total_size_y), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		expand_tween.interpolate_property(self, "rect_min_size", Vector2(0, 24), Vector2(0, total_size_y), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		expand_tween.start()
	else:
		var total_size_y = 24 + descr_label.get_line_count() * 10 + 8
		if type == "item":
			total_size_y += 14
		contract_tween.interpolate_property(background, "rect_size", Vector2(320, total_size_y), Vector2(320, 24), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		contract_tween.interpolate_property(self, "rect_min_size", Vector2(0, total_size_y), Vector2(0, 24), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		contract_tween.start()
		descr_label.visible = false

func _on_ExpandTween_tween_all_completed():
	descr_label.visible = true
	if type == "item":
		get_node("ResourceMission").visible = true
