extends Structure

const interface = preload("res://Structures/Cage/Interface/CageInterface.tscn")

var creature: String
var empty: bool = false
var level: int = 1

var collide = true

signal collision_disabled

func extra_init():
	var path: String = "res://Structures/Cage/Creatures/" + creature + ".png"
	
	var directory = Directory.new()
	if directory.file_exists(path):
		empty = false
		get_node("Creature").texture = load(path)
	else:
		empty = true
		get_node("Transparent").modulate.a = 1

func object_interacted_with():
	var i = interface.instance()
	i.creature = creature
	i.empty = empty
	i.level = level
	i.connect("free", self, "mob_freed")
	get_tree().get_current_scene().set_gui_window(i)

func _process(_delta):
	collision = collide
	emit_signal("collision_disabled")

func mob_freed():
	collide = false
	yield(self, "collision_disabled")
	var pos = global_position + Vector2(0, 4)
	var mob = get_tree().get_current_scene().spawn_mob(creature.to_lower(), pos.x, pos.y)
	mob.level = level
	mob.initialize()
	get_tree().get_current_scene().close_gui_window()
	queue_free()

func save():
	var save_dict = {
		"filename" : get_filename(),
		"id" : "structure",
		"pos_x" : position.x,
		"pos_y" : position.y,
		"creature" : creature,
		"level" : level
		}
	return save_dict

func load_from_save(data):
	global_position.x = data["pos_x"]
	global_position.y = data["pos_y"]
	creature = data["creature"]
	level = data["level"]
	extra_init()
