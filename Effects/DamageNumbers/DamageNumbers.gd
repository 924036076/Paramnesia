extends Label

func _ready():
	get_node("AnimationPlayer").play("Fade")

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
