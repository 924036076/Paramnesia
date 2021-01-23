extends Control

func _ready():
# warning-ignore:return_value_discarded
	PlayerData.connect("coins_changed", self, "update_coins")
	update_coins()

func update_coins():
	get_node("Amount").text = str(PlayerData.coins)
