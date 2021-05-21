extends KinematicBody2D

var velocity: Vector2 = Vector2.ZERO
var direction: Vector2
var collided: bool = false

func _physics_process(delta):
	if collided:
		queue_free()

	velocity = direction * delta * 100
	var collision = move_and_collide(velocity)
	if collision != null:
		collided = true

func get_damage_info() -> Dictionary:
	collided = true
	
	var damage: Dictionary = {
		"damage": 5,
		"reference": get_tree().get_current_scene().get_node("GlobalYSort/Player"),
		"knockback" : direction * 10,
		"type" : "tame"
	}
	return damage

func _on_Timer_timeout():
	collided = true
