extends Control

func _ready():
# warning-ignore:return_value_discarded
	PlayerData.connect("coins_changed", self, "update_coins")
	PlayerData.connect("day_changed", self, "update_days")
	update_coins()
	update_days()

func update_coins():
	get_node("CoinsAmount").text = str(PlayerData.coins)

func update_days():
	get_node("Day").text = PlayerData.season + " " + str(PlayerData.day)
