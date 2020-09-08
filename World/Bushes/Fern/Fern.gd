extends Node2D

onready var health_bar = get_node("ResourceIndicator")
var berries

func _ready():
	get_node("Sprite").frame = (randi() % 2)
	berries = get_node("Sprite").frame == 0
	health_bar.connect("no_health", self, "destroy_fern")

func _on_Hurtbox_area_entered(_area):
	if PlayerData.can_pick():
		if berries:
			PlayerData.add_to_inventory(0, "berry", 1, true)
			berries = false
			get_node("Sprite").frame = 1
		else:
			PlayerData.add_to_inventory(0, "fiber", 5, true)
			health_bar.health = health_bar.health - 20

func destroy_fern():
	queue_free()
