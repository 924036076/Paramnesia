extends Node

const command_words = [["teleport", [2]], ["spawn", [1, 3]], ["give_item", [1, 2]]]
const spawnable_mobs = ["deer", "bat"]

func teleport(x_coord, y_coord):
	var x = str2var(x_coord)
	var y = str2var(y_coord)
	if typeof(x) != TYPE_INT or typeof(y) != TYPE_INT:
		return str("-Invalid parameter types (int, int required)-")
	get_tree().get_current_scene().teleport(x, y)
	return str("~Teleporting to (" + str(x) + ", " + str(y) + ")~")

func spawn(obj, x_coord = "-37", y_coord = "37"):
	var mob = obj.to_lower()
	x_coord = str2var(x_coord)
	y_coord = str2var(y_coord)
	if typeof(x_coord) != TYPE_INT or typeof(y_coord) != TYPE_INT:
		return str("-Invalid parameter types (int, int required)-")
	if spawnable_mobs.find(mob) < 0:
		return str('-"' + obj + '" is not a valid spawn-')
	get_tree().get_current_scene().spawn_mob(mob, x_coord, y_coord)
	return str("~Spawning " + obj + "~")

func give_item(item_id, num = "1"):
	num = str2var(num)
	item_id = item_id.to_lower()
	if ItemDictionary.get_item(item_id)["type"] == null:
		return str('-"' + item_id + '" is not a valid item-')
	if typeof(num) != TYPE_INT:
		return ('-"' + str(num) + '" is not a whole number-')
	PlayerData.add_to_inventory(0, item_id, num, true)
	return str("~Giving " + str(num) + " " + item_id + " to player~")
