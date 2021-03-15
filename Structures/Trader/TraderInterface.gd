extends Control

onready var buy_button = get_node("BuyButton")
onready var sell_button = get_node("SellButton")
onready var buy_tab = get_node("Buy")
onready var sell_tab = get_node("Sell")

var stock: Array = []

func _ready():
	buy_button.disabled = true
	sell_button.disabled = false
	
	buy_tab.visible = true
	buy_tab.set_process_input(true)
	sell_tab.visible = false
	sell_tab.set_process_input(false)
	

func _on_BuyButton_pressed():
	buy_button.disabled = true
	sell_button.disabled = false
	
	buy_tab.visible = true
	buy_tab.set_process_input(true)
	sell_tab.visible = false
	sell_tab.set_process_input(false)

func _on_SellButton_pressed():
	buy_button.disabled = false
	sell_button.disabled = true
	
	buy_tab.visible = false
	buy_tab.set_process_input(false)
	sell_tab.visible = true
	sell_tab.set_process_input(true)
