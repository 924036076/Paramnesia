extends KinematicBody2D

class_name Character

enum {
	LEFT,
	RIGHT,
	UP,
	DOWN
}

enum {
	WALK,
	IDLE
}

onready var animation_player = get_node("AnimationPlayer")
onready var sprite = get_node("Sprite")

export var speed = 500
export var health = 100

var dir = LEFT
var state = WALK
var elapsed_time = 0

func _ready():
	sprite.set_material(sprite.get_material().duplicate())

func _physics_process(delta):
	elapsed_time += delta
	match state:
		WALK:
			walk_state(delta)
		IDLE:
			idle_state()

func walk_state(delta):
	var velocity
	match dir:
		LEFT:
			velocity = Vector2(-speed * delta, 0)
			animation_player.play("WalkLeft")
		RIGHT:
			velocity = Vector2(speed * delta, 0)
			animation_player.play("WalkRight")
		UP:
			velocity = Vector2(0, -speed * delta)
			animation_player.play("WalkUp")
		DOWN:
			velocity = Vector2(0, speed * delta)
			animation_player.play("WalkDown")
	velocity = move_and_slide(velocity)
	if velocity == Vector2(0, 0):
		elapsed_time = 0
		choose_new_direction()
	if elapsed_time > 2:
		elapsed_time = 0
		choose_new_direction()

func idle_state():
	pass

func choose_new_direction():
	dir = randi() % 4

func _on_Hurtbox_area_entered(_area):
	health -= 50
	if health <= 0:
		dead()

func dead():
	pass

func interact():
	pass

func _on_InteractArea_mouse_entered():
	sprite.get_material().set_shader_param("line_thickness", 1)

func _on_InteractArea_mouse_exited():
	sprite.get_material().set_shader_param("line_thickness", 0)

func _on_InteractArea_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("inventory_alt"):
		interact()
