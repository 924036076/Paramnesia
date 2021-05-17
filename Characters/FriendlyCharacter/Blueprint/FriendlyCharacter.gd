extends Character

class_name FriendlyCharacter

export var CAN_ATTACK: bool = true

func set_direction(direction: Vector2):
	animation_tree.set("parameters/Idle/blend_position", direction)
	animation_tree.set("parameters/Walk/blend_position", direction)
