extends Structure

func object_interacted_with():
	get_node("Flames").emitting = not get_node("Flames").emitting
