extends YSort

onready var sprite = get_node("TextureRect")
onready var area = get_node("Area2D")

export var do_raft: bool = false
var hitched: bool = true

func _ready():
	get_node("RaftAnchor2/Sprite").set_material(get_node("RaftAnchor/Sprite").get_material())

func _process(_delta):
	if do_raft:
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

func _on_RaftAnchor_toggle_hitch():
	hitched = not hitched
	var player = get_tree().get_current_scene().get_node("GlobalYSort/Player")
	if hitched:
		player.global_position = get_node("PlayerSpawn").global_position + Vector2(0, -80)
		get_node("RaftAnchor2").toggle_active(true)
		get_node("RaftAnchor2/Rope").visible = true
	else:
		player.global_position = get_node("PlayerSpawn").global_position
		get_node("RaftAnchor2").toggle_active(false)
		get_node("RaftAnchor2/Rope").visible = false
