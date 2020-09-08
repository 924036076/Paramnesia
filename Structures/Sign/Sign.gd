extends InteractableObject

const sign_text = preload("res://Structures/Sign/SignText.tscn")

export var text = ""

func interact():
	var new_sign = sign_text.instance()
	new_sign.get_node("Label").text = text
	Global.current_scene.get_node("GUI").add_child(new_sign)
