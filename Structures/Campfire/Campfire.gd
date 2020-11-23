extends Structure

func object_interacted_with():
	get_node("Flames").emitting = not get_node("Flames").emitting

func save():
	var save_dict = {
		"filename" : get_filename(),
		"id" : "structure",
		"pos_x" : position.x,
		"pos_y" : position.y,
		"emitting": get_node("Flames").emitting
		}
	return save_dict

func load_from_save(data):
	global_position.x = data["pos_x"]
	global_position.y = data["pos_y"]
	get_node("Flames").emitting = data["emitting"]
