extends PathFollow2D

var moving =  true

func _process(delta):
	if moving:
		offset += delta * 20
