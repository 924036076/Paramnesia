extends KinematicBody2D

onready var animation_player = get_node("AnimationPlayer")
onready var health_bar = get_node("HealthBar")
onready var hurtbox = get_node("Hurtbox")
onready var sprite = get_node("Sprite")
onready var hit_timer = get_node("HitEffect")

enum {
	LEFT,
	RIGHT,
	UP,
	DOWN
}

enum {
	WANDER,
	PATH
}

enum {
	WALK,
	ATTACK
}

var dir = RIGHT
var state = WALK
var goal = WANDER

func _ready():
	sprite.set_material(sprite.get_material().duplicate())

func _physics_process(delta):
	match state:
		WALK:
			walk(delta)
		ATTACK:
			attack()

func walk(delta):
	pass

func attack():
	pass

func dead():
	var splatter = load("res://Effects/Disappear/Disappear.tscn").instance()
	add_child(splatter)
	set_physics_process(false)
	animation_player.stop()

func _on_Hurtbox_area_entered(area):
	if area.has_method("get_damage"):
		area.get_parent().hit()
		sprite.get_material().set_shader_param("highlight", true)
		hit_timer.start()
		health_bar.health -= area.get_damage()
		hurtbox.start_invicibility(1)

func _on_HitEffect_timeout():
	sprite.get_material().set_shader_param("highlight", false)
