extends Node2D

onready var sprite = get_node("Sprite")

func _ready():
	randomize()
	sprite.frame = (randi() % 8)

func _on_Hurtbox_area_entered(_area):
	if PlayerData.can_pick():
		PlayerData.add_to_inventory(0, "stone", 1, true)
		queue_free()
