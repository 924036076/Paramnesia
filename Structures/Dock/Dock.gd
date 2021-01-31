extends StaticBody2D

func open():
	get_node("Edge").disabled = true

func close():
	get_node("Edge").disabled = false
