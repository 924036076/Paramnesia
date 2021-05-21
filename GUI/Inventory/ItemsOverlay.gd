extends Control

onready var selected = get_node("SelectedItem")
onready var back = get_node("BackItem")

func _ready():
# warning-ignore:return_value_discarded
	PlayerData.connect("inventory_updated", self, "redraw")
	redraw()

func redraw():
	if PlayerData.holding == 0:
		selected.self_modulate = Color("#bca2db")
		back.self_modulate = Color("#879ce3")
	else:
		selected.self_modulate = Color("#879ce3")
		back.self_modulate = Color("#bca2db")

	var primary_item = PlayerData.get_item_at_slot(PlayerData.holding)
	if primary_item != null:
		selected.get_node("TextureRect").texture = load(ItemDictionary.get_item(primary_item.id)["icon"])
		if primary_item.amount > 1:
			selected.get_node("Label").text = "x " + str(primary_item.amount)
		else:
			selected.get_node("Label").text = ""
	var secondary_item = PlayerData.get_item_at_slot(1 - PlayerData.holding)
	if secondary_item != null:
		back.get_node("TextureRect").texture = load(ItemDictionary.get_item(secondary_item.id)["icon"])
		if secondary_item.amount > 1:
			back.get_node("Label").text = "x " + str(secondary_item.amount)
		else:
			back.get_node("Label").text = ""
