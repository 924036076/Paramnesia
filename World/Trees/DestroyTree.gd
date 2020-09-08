extends Node2D

enum {
	RIGHT,
	LEFT
}

var fall_dir

func _process(delta):
	match fall_dir:
		RIGHT:
			self.rotation = self.rotation + delta
		LEFT:
			self.rotation = self.rotation - delta
	if abs(self.rotation_degrees) > 90:
		queue_free()
