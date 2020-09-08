extends TextureProgress

func _ready():
	PlayerData.connect("water_changed", self, "set_progress")
	value = PlayerData.water

func set_progress(passed_value):
	value = passed_value
