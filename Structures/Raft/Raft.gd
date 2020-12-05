extends YSort

onready var sprite = get_node("TextureRect")
onready var area = get_node("Area2D")

func _process(_delta):
	var player = get_tree().get_current_scene().get_node("GlobalYSort/Player")
	var path = get_node("../Path2D/PathFollow2D")
	if area.overlaps_body(player):
		path.moving = true
		var old_pos = position
		position = path.position - Vector2(sprite.rect_size.x / 2, sprite.rect_size.y / 2)
		var change = position - old_pos
		player.position += change
	else:
		path.moving = false

func _on_Area2D_input_event(_viewport, _event, _shape_idx):
	var player = get_tree().get_current_scene().get_node("GlobalYSort/Player")
	if Input.is_action_just_pressed("inventory_alt") and not area.overlaps_body(player):
		player.global_position = get_node("PlayerSpawn").global_position
