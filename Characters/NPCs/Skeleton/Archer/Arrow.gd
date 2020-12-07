extends KinematicBody2D

export var direction = Vector2.ZERO
export var max_speed = 20

var sound = load("res://Audio/fork_media_warfare_arrow_impact.wav")

var velocity

func _physics_process(delta):
	if (get_slide_count() > 0):
		queue_free()
	
	velocity = direction * max_speed * delta * 500
	velocity = move_and_slide(velocity)

func hit():
	AudioManager.play_ui_sfx(sound)
	queue_free()

func _on_Timeout_timeout():
	queue_free()
