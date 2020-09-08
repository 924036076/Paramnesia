extends TextureRect

const item_base = preload("res://Control/ItemBasePlain.tscn")
const item_label = preload("res://Control/ItemLabel.tscn")

onready var icon = get_node("Icon")
onready var item_name = get_node("ItemName")
onready var description = get_node("Description")
onready var craft_amount = get_node("Amount")

var clear_list = []
var selected_blueprint
var selected_item_id
var passed_button
var passed_index
var shift = false

func _ready():
	PlayerData.connect("inventory_updated", self, "redraw_last")

func redraw_last():
	if passed_index != null:
		redraw(passed_index, passed_button)

func redraw(index, button):
	clear_nodes()
	passed_button = button
	passed_index = index
	
	selected_blueprint = return_craftable_blueprint(index)
	
	icon.rect_position = Vector2(8, 8)
	icon.texture = load(selected_blueprint["icon"])
	
	item_name.text = selected_blueprint["name"]
	
	if selected_blueprint["level"] > PlayerData.level:
		button.modulate.a = 0.5
		icon.modulate.a = 0.5
		if selected_blueprint["level"] == 99:
			description.text = "Unlocked by completing a quest"
		else:
			description.text = "Unlocked at level " + str(selected_blueprint["level"])
	else:
		button.modulate.a = 1
		icon.modulate.a = 1
		description.text = selected_blueprint["description"]
	
	var item_recipe = selected_blueprint["recipe"]
	
	if shift:
		craft_amount.visible = true
		craft_amount.text = "(" + str(max_craftable_current_item()) + ")"
	else:
		craft_amount.visible = false
	
	var num_mats = 0
	for material in item_recipe:
		num_mats = num_mats + 1
		var material_texture = item_base.instance()
		material_texture.texture = load(ItemDictionary.get_item(material[0])["icon"])
		material_texture.rect_position = Vector2(6, (num_mats - 1) * 10 + 47)
		material_texture.rect_scale = Vector2(0.5, 0.5)
		add_child(material_texture)
		clear_list.append(material_texture)
		var material_count = item_label.instance()
		material_count.text = "x " + str(material[1])
		material_count.rect_position = Vector2(18, (num_mats - 1) * 10 + 50)
			
		var count = PlayerData.get_num_held(material[0])
		var material_inventory_count = item_label.instance()
		material_inventory_count.text = "( " + str(count) + " )"
		material_inventory_count.rect_position = Vector2(35, (num_mats - 1) * 10 + 50)
		if count >= material[1]:
			material_inventory_count.set("custom_colors/font_color",Color(0,1,0))
		else:
			material_inventory_count.set("custom_colors/font_color",Color(1,0,0))
		add_child(material_inventory_count)
		clear_list.append(material_inventory_count)
		add_child(material_count)
		clear_list.append(material_count)

func max_craftable_current_item():
	return clamp(PlayerData.max_craftable(selected_blueprint["recipe"]), 0, 100)

func clear_nodes():
	for item in clear_list:
		item.queue_free()
	clear_list = []

func can_craft_current_item():
	return selected_blueprint["level"] <= PlayerData.level

func return_craftable_blueprint(index):
	var blueprint = 0
	var selected_craftable_blueprint = null
	for item in ItemDictionary.ITEMS:
		if ItemDictionary.get_item(item)["craftable"]:
			blueprint = blueprint + 1
			if blueprint == index:
				selected_craftable_blueprint = ItemDictionary.get_item(item)
				selected_item_id = item
	return selected_craftable_blueprint
