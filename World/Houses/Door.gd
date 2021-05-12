extends StaticStructure

signal door_opened

func object_interacted_with():
	has_focus = false
	Global.num_interacted_with = 0
	sprite.get_material().set_shader_param("line_thickness", 0)
	emit_signal("door_opened")
