extends Node2D

class_name Interior

func _ready():
# warning-ignore:return_value_discarded
	get_node("GlobalYSort/Objects/ExitDoor").connect("door_opened", self, "door_opened")

func door_opened():
	Global.exit_interior()
