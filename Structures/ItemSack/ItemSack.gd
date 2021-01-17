extends Structure

const interface = preload("res://Structures/ItemSack/Interface/ItemSackInterface.tscn")

var inventory: Array = []

func object_interacted_with():
	var i = interface.instance()
	i.inventory = inventory
	i.connect("inventory_changed", self, "inventory_changed")
	get_tree().get_current_scene().set_gui_window(i)

func inventory_changed():
	if inventory.size() == 0:
		get_node("CloseDelay").start()

func _on_ItemSack_tree_exiting():
	get_tree().get_current_scene().close_gui_window()

func _on_CloseDelay_timeout():
	queue_free()
