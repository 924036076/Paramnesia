extends Control

var dummy = null

func _ready():
	get_node("KnockbackSlider").value = dummy.knockback_resistance
	get_node("Label1").text = str(dummy.knockback_resistance)
	get_node("ArmorSlider").value = dummy.damage_resistance
	get_node("Label2").text = str(dummy.damage_resistance)
	get_node("AnchoredButton").pressed = dummy.anchored

func _on_KnockbackSlider_value_changed(value):
	dummy.knockback_resistance = value
	get_node("Label1").text = str(dummy.knockback_resistance)

func _on_ArmorSlider_value_changed(value):
	dummy.damage_resistance = value
	get_node("Label2").text = str(dummy.damage_resistance)

func _on_AnchoredButton_toggled(button_pressed):
	dummy.anchored = button_pressed

func _on_PickupButton_pressed():
	PlayerData.add_to_inventory(0, "target_dummy", 1)
	dummy.queue_free()
	get_parent().close_open_window()
