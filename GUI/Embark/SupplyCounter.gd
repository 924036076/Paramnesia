extends Control

var max_amount: int = 0 setget set_max_amount
var current_amount: int = 0

func set_max_amount(new_amount):
	max_amount = new_amount
	update_amount_indicator()
	
func update_amount_indicator():
	get_node("HBoxContainer/Amount").text = str(current_amount) + "/" + str(max_amount)

func _on_MinusButton_pressed():
	if current_amount > 0:
		current_amount -= 1
		update_amount_indicator()
		get_parent().available_points += 1
		if current_amount == 0:
			get_node("HBoxContainer/MinusButton").disabled = true
		get_node("HBoxContainer/PlusButton").disabled = false

func _on_PlusButton_pressed():
	if current_amount < max_amount and get_parent().available_points > 0:
		current_amount += 1
		update_amount_indicator()
		get_parent().available_points -= 1
		if current_amount == max_amount:
			get_node("HBoxContainer/PlusButton").disabled = true
		get_node("HBoxContainer/MinusButton").disabled = false

func set_plus_enabled():
	if current_amount < max_amount:
		get_node("HBoxContainer/PlusButton").disabled = false

func set_plus_disabled():
	get_node("HBoxContainer/PlusButton").disabled = true
	
