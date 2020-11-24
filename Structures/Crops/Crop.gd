extends Structure

export var type: int = 0

onready var timer = get_node("Timer")

var grow_state = 0

func extra_init():
	sprite.frame = type * 4

func _on_Timer_timeout():
	grow_state += 1
	sprite.frame = type * 4 + grow_state
	if grow_state > 2:
		timer.queue_free()

func save():
	var save_dict = {
		"filename" : get_filename(),
		"id" : "structure",
		"pos_x" : position.x,
		"pos_y" : position.y,
		"type": type,
		"state": grow_state
		}
	return save_dict

func load_from_save(data):
	global_position.x = data["pos_x"]
	global_position.y = data["pos_y"]
	type = data["type"]
	grow_state = data["state"]
	sprite.frame = type * 4 + grow_state
