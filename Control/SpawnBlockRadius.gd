extends Area2D

export var destroy = true
export var destroy_others = true

func _on_SpawnBlockRadius_area_entered(area):
	if destroy and area.destroy_others:
		get_parent().queue_free()

