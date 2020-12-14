extends KinematicBody2D

const floating_numbers = preload("res://Effects/DamageNumbers/FriendlyNumbers.tscn")
const interface = preload("res://Structures/Dummy/TargetDummyInterface.tscn")

onready var sprite = get_node("Sprite")

var knockback: Vector2 = Vector2.ZERO
var has_focus: bool = false
var anchored: bool = false
var damage_resistance: int = 0
var knockback_resistance: int = 50

func _ready():
	sprite.set_material(sprite.get_material().duplicate())

func _physics_process(delta):
	if not anchored:
		knockback = knockback.move_toward(Vector2.ZERO, delta * (200 + knockback_resistance * 4))
		knockback = move_and_slide(knockback)
	else:
		knockback = Vector2.ZERO

func _on_HitEffect_timeout():
	sprite.get_material().set_shader_param("highlight", false)

func _on_Hurtbox_area_entered(area):
	var damage = 0
	if area.get_parent().has_method("get_damage"):
		damage = area.get_parent().get_damage()
	if area.get_parent().has_method("resolve_hit"):
		area.get_parent().resolve_hit()
	if area.get_parent().has_method("get_knockback"):
		knockback = area.get_parent().get_knockback()
	damage -= damage_resistance
	damage = max(0, damage)
	sprite.get_material().set_shader_param("highlight", true)
	get_node("HitEffect").start()
	
	var numbers = floating_numbers.instance()
	numbers.text = str(damage)
	add_child(numbers)

func _on_InteractArea_mouse_entered():
	Utility.try_to_grab_focus(self)

func _on_InteractArea_mouse_exited():
	if has_focus:
		has_focus = false
		Global.num_interacted_with = 0
	sprite.get_material().set_shader_param("line_thickness", 0)

func _on_InteractArea_input_event(_viewport, _event, _shape_idx):
	Utility.try_to_grab_focus(self)
	if Input.is_action_just_pressed("inventory_alt") and has_focus:
		interacted_with()

func interacted_with():
	var i = interface.instance()
	i.dummy = self
	get_tree().get_current_scene().get_node("GUI").current_window = i
