extends Control

const item_base = preload("res://GUI/ObjectInventory/InventoryItem.tscn")
const item_background = preload("res://GUI/ObjectInventory/ItemBackground.tscn")

func _ready():
# warning-ignore:return_value_discarded
	PlayerData.connect("inventory_updated", self, "redraw")
	redraw()

func redraw():
	Utility.delete_children(self)
	var x = 0
	var y = 0
	for i in range(0, 8):
		var panel = item_background.instance()
		panel.rect_position = Vector2(x - 4, y - 4)
		add_child(panel)
		if i < PlayerData.inventory.size():
			var slot = PlayerData.inventory[i]
			var id = slot[0]
			var num = slot[1]
		
			var item = item_base.instance()
			item.get_node("TextureRect").texture = load(ItemDictionary.get_item(id)["icon"])
			if num > 0:
				item.get_node("Label").text = "x " + str(num)
			item.rect_position = Vector2(x, y)
			add_child(item)
		x += 42

