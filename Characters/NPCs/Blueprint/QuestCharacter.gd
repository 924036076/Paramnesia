extends KinematicBody2D

class_name QuestCharacter

onready var sprite = get_node("Sprite")
onready var animation_player = get_node("AnimationPlayer")
onready var animation_tree = get_node("AnimationTree")
onready var animation_state = animation_tree.get("parameters/playback")

export var MAX_SPEED: int = 10
export var ACCELERATION: int = 50

enum {
	WALK,
	IDLE
}

var dir: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var state = WALK
var has_focus: bool = false

func _ready():
	animation_tree.active = true
	animation_state.start("Walk")
	
	random_direction()
	set_direction(dir)
	
	sprite.set_material(sprite.get_material().duplicate())

func _physics_process(delta):
	match state:
		WALK:
			walk(delta)

func walk(delta):
	velocity = velocity.move_toward(dir * MAX_SPEED, ACCELERATION * delta)
	velocity = move_and_slide(velocity)

func set_direction(direction):
	animation_tree.set("parameters/Walk/blend_position", direction)

func random_direction():
	var dir_x = randi() % 10 - 5
	var dir_y = randi() % 10 - 5
	dir = Vector2(dir_x, dir_y).normalized()

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
	print("interacted with")
