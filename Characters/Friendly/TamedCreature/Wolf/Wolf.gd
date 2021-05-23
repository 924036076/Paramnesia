extends TamedCreature

func _on_Sprite_frame_changed():
	get_node("CollarSprite").frame = get_node("Sprite").frame
