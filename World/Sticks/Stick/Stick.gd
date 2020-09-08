extends Node2D

onready var sprite = get_node("Sprite")

func _ready():
	randomize()
	sprite.flip_h = (randi() % 2 > 0)
	sprite.flip_v = (randi() % 2 > 0)

func _on_Hurtbox_area_entered(_area):
	if PlayerData.can_pick():
		PlayerData.add_to_inventory(0, "wood", 1, true)
		queue_free()
