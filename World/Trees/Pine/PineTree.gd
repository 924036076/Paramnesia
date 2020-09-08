extends Node2D

const MOD_AMOUNT = 0.6

var trans_counter = 0
onready var health_bar = get_node("ResourceIndicator")
onready var sprite = get_node("Sprite")

enum {
	RIGHT,
	LEFT
}

func _ready():
	health_bar.connect("no_health", self, "fell_tree")

func _on_Hurtbox_area_entered(_area):
	if PlayerData.get_item_held() == "stone_axe":
		health_bar.health = health_bar.health - 20

func fell_tree():
	var FellEffect = load("res://World/Trees/Pine/DestroyPineTree.tscn")
	var fellEffect = FellEffect.instance()
	get_parent().add_child(fellEffect)
	fellEffect.global_position = global_position
	if fellEffect.global_position.x < get_parent().get_parent().get_parent().get_node("YSort/Player").global_position.x:
		fellEffect.fall_dir = LEFT
	else:
		fellEffect.fall_dir = RIGHT
	queue_free()

func _on_TransTest_area_entered(_area):
	sprite.modulate.a = MOD_AMOUNT
	trans_counter += 1

func _on_TransTest_area_exited(_area):
	trans_counter -= 1
	if trans_counter == 0:
		sprite.modulate.a = 1
