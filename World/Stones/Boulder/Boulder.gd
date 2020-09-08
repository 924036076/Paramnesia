extends StaticBody2D

onready var health_bar = get_node("ResourceIndicator")

func _ready():
	get_node("Sprite").frame = (randi() % 6)
	health_bar.connect("no_health", self, "destroy_this")

func _on_Hurtbox_area_entered(_area):
	if PlayerData.get_item_held() == "stone_axe":
		health_bar.health = health_bar.health - 20

func destroy_this():
	queue_free()
