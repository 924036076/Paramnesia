extends AnimatedSprite

func _ready():
	playing = true

func _on_Disappear_animation_finished():
	get_parent().queue_free()
