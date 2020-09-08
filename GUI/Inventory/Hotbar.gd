extends TextureRect

const item_base = preload("res://Control/ItemBase.tscn")
const item_base_plain = preload("res://Control/ItemBasePlain.tscn")

func _ready():
	PlayerData.connect("inventory_updated", self, "redraw")
	redraw()

func redraw():
	Utility.delete_children(self)
	for i in range(0, 8):
		var item = PlayerData.inventory[i]
		if item[0] != null:
			var base = item_base.instance()
			if ItemDictionary.get_item(item[0])["stack"] == 1:
				base = item_base_plain.instance()
			else:
				base.value = item[1]
			base.texture = load(ItemDictionary.get_item(item[0])["icon"])
			base.rect_position = Vector2(25 * i + 6, 6)
			add_child(base)

