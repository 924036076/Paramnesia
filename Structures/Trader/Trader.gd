extends YSort

const packed_cage = preload("res://Structures/Cage/Cage.tscn")
const packed_pedestal = preload("res://Structures/Trader/Pedestal.tscn")
const interface = preload("res://Structures/Trader/TraderInterface.tscn")

onready var sprite = get_node("Sprite")

const SPEED: float = 50.0

var stock: Array = []
var path: PathFollow2D
var travel: bool = true
var has_focus: bool = false

signal docked

func _ready():
	sprite.set_material(sprite.get_material().duplicate())
	sprite.get_material().set_shader_param("line_thickness", 0)
	
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
				cage.can_interact = false
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

func _on_InteractArea_mouse_entered():
	if not travel:
		try_to_grab_focus()

func _on_InteractArea_mouse_exited():
	if has_focus:
		has_focus = false
		Global.num_interacted_with = 0
	sprite.get_material().set_shader_param("line_thickness", 0)

func _on_InteractArea_input_event(_viewport, _event, _shape_idx):
	if not travel:
		try_to_grab_focus()
		if Input.is_action_just_pressed("inventory_alt") and has_focus:
			object_interacted_with()

func try_to_grab_focus():
	if Global.num_interacted_with < 1:
		has_focus = true
		Global.num_interacted_with = 1
		sprite.get_material().set_shader_param("line_thickness", 1)

func object_interacted_with():
	var i = interface.instance()
	i.stock = stock
	get_tree().get_current_scene().set_gui_window(i)
