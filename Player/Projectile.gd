extends KinematicBody2D

export var direction = Vector2.ZERO
export var max_speed = 500

const hit_effect = preload("res://Effects/HitMarker/HitMarker.tscn")

var velocity

func _physics_process(delta):
	if (get_slide_count() > 0):
		queue_free()
	
	velocity = direction * max_speed * delta * 500
	velocity = move_and_slide(velocity)

func _on_Timer_timeout():
	queue_free()

func _on_Hitbox_area_entered(_area):
	var hit = hit_effect.instance()
	hit.global_position = get_node("HitLocation").global_position
	get_parent().add_child(hit)
	queue_free()
