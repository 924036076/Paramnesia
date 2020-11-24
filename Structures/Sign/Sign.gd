extends Structure

const animated_text = preload("res://Structures/Sign/SignText.tscn")

export var message: String = ""

var message_scene = null

func object_interacted_with():
	if message_scene != null:
		message_scene.queue_free()
	message_scene = animated_text.instance()
	message_scene.text = message
	message_scene.connect("freed", self, "text_freed")
	add_child(message_scene)
	message_scene.rect_position += Vector2(0, -40)

func save():
	var save_dict = {
		"filename" : get_filename(),
		"id" : "structure",
		"pos_x" : position.x,
		"pos_y" : position.y,
		"text": message
		}
	return save_dict

func load_from_save(data):
	global_position.x = data["pos_x"]
	global_position.y = data["pos_y"]
	message = data["text"]

func text_freed():
	message_scene = null
