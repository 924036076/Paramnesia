extends Node2D

class_name NatureTree

const FellEffect = preload("res://World/Trees/DestroyTree.tscn")
const MOD_AMOUNT = 0.6

onready var health_bar = get_node("ResourceIndicator")
onready var sprite = get_node("Sprite")

var trans_counter = 0

enum {
	RIGHT,
	LEFT
}

func _ready():
	health_bar.connect("no_health", self, "fell_tree")

func fell_tree():
	var fellEffect = FellEffect.instance()
	fellEffect.get_node("Sprite").position = get_node("Sprite").position
	fellEffect.get_node("Sprite").texture = get_node("Sprite").texture
	get_parent().add_child(fellEffect)
	fellEffect.global_position = global_position
	if fellEffect.global_position.x < get_tree().get_current_scene().get_node("GlobalYSort/Player").global_position.x:
		fellEffect.fall_dir = LEFT
	else:
		fellEffect.fall_dir = RIGHT
	queue_free()

func _on_Hurtbox_area_entered(_area):
	if PlayerData.get_item_held() == "stone_axe":
		health_bar.health = health_bar.health - 20

func _on_TransTest_area_entered(_area):
	sprite.modulate.a = MOD_AMOUNT
	trans_counter += 1

func _on_TransTest_area_exited(_area):
	trans_counter -= 1
	if trans_counter == 0:
		sprite.modulate.a = 1

func save():
	var save_dict = {
		"filename" : get_filename(),
		"id" : "nature",
		"pos_x" : global_position.x,
		"pos_y" : global_position.y,
		}
	return save_dict

func load_from_save(data):
	global_position.x = data["pos_x"]
	global_position.y = data["pos_y"]
