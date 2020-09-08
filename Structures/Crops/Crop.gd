extends InteractableObject

export var type = 1

func extra_init():
	sprite.frame = (type - 1) * 4

func _on_Timer_timeout():
	if sprite.frame < (type - 1) * 4 + 3:
		sprite.frame += 1
	else:
		get_node("Timer").queue_free()
