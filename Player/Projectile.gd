extends KinematicBody2D

export var direction = Vector2.ZERO
export var max_speed = 500

const hit_effect = preload("res://Effects/HitMarker/HitMarker.tscn")
var sound = load("res://Audio/fork_media_warfare_arrow_impact.wav")

var velocity

func _physics_process(delta):
	if (get_slide_count() > 0):
		queue_free()
	
	velocity = direction * max_speed * delta * 500
	velocity = move_and_slide(velocity)

func _on_Timer_timeout():
	queue_free()

func hit():
	AudioManager.play_ui_sfx(sound)
	var hit = hit_effect.instance()
	hit.global_position = get_node("HitLocation").global_position
	get_parent().add_child(hit)
	queue_free()
