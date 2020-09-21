extends Node2D

onready var remote_transform = load("res://World/Scenes/SceneBlueprint/RemoteTransform2D.tscn")
export var save_path = ""

func load_from_save():
	var remote_follow = remote_transform.instance()
	get_node("GlobalYSort/Player").add_child(remote_follow)
	remote_follow.remote_path = "../../../Camera2D"
