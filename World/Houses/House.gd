extends StaticBody2D

export var interior_path: String
export var door_direction: Vector2 = Vector2(0, 1)

func _ready():
# warning-ignore:return_value_discarded
	get_node("Door").connect("door_opened", self, "door_opened")

func door_opened():
	get_tree().get_current_scene().get_node("GlobalYSort/Player").set_direction(door_direction)
	get_tree().get_current_scene().get_node("GlobalYSort/Player").global_position = get_node("Door").global_position + Vector2(0, 10)
	Global.enter_interior(interior_path)
