extends YSort

const packed_cage = preload("res://Structures/Cage/Cage.tscn")
const packed_pedestal = preload("res://Structures/Trader/Pedestal.tscn")

const SPEED: float = 10.0

var stock: Array = []
var path: PathFollow2D
var travel: bool = true

signal docked

func _ready():
	stock = Global.shop_loot_table.roll_table()
	var creatures = ["Cow", "Pig", "Goat", "Chicken", "Sheep", "Rabbit", "Duck"]
	
	for i in range(stock.size()):
		var creature_flag: bool = false
		var item: String = stock[i][0]
		
		for j in range(creatures.size()):
			if creatures[j].to_lower() == item:
				var cage = packed_cage.instance()
				cage.creature = item
				cage.level = 1
				cage.position = get_node("Pedestals").get_children()[i].position
				add_child(cage)
				creature_flag = true
				break

		if not creature_flag:
			var pedestal = packed_pedestal.instance()
			pedestal.position = get_node("Pedestals").get_children()[i].position
			pedestal.get_node("Item").texture = load(ItemDictionary.get_item(item)["icon"])
			add_child(pedestal)

func _physics_process(delta):
	if travel:
		path.unit_offset += (SPEED / 500) * delta
		global_position = path.global_position
		if path.unit_offset >= 1:
			travel = false
			emit_signal("docked")
