extends AnimatedSprite

func _ready():
	playing = true

func _on_HitMarker_animation_finished():
	queue_free()
