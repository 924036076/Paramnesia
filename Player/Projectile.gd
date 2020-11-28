extends KinematicBody2D

export var direction = Vector2.ZERO
export var max_speed = 500

var velocity

func _physics_process(delta):
	if (get_slide_count() > 0):
		queue_free()
	
	velocity = direction * max_speed * delta * 500
	velocity = move_and_slide(velocity)

func _on_Timer_timeout():
	queue_free()
