extends Node

const ICON_PATH = "res://Icons/"
const ITEMS = {
	"stone_axe": {
		"icon": ICON_PATH + "stone_axe.png",
		"name": "Stone Axe",
		"type": "tool",
		"subtype": "axe",
		"stack": 1,
		"craftable": true,
		"level": 1,
		"recipe":[["wood", 5], ["stone", 5], ["fiber", 8]],
		"description": "A primitive tool for chopping wood"
	},
	"stone_pickaxe": {
		"icon": ICON_PATH + "stone_pickaxe.png",
		"name": "Stone Pickaxe",
		"type": "tool",
		"subtype": "pickaxe",
		"stack": 1,
		"craftable": true,
		"level": 1,
		"recipe":[["wood", 30], ["stone", 10], ["fiber", 10]],
		"description": "A primitive tool for mining stone"
	},
	"campfire": {
		"icon": ICON_PATH + "campfire.png",
		"name": "Campfire",
		"type": "structure",
		"subtype": null,
		"stack": 10,
		"craftable": true,
		"level": 2,
		"recipe":[["wood", 20], ["stone", 20]],
		"description": "Essential for light and cooking"
	},
	"cooking_pot": {
		"icon": ICON_PATH + "cooking_pot.png",
		"name": "Cooking Pot",
		"type": "structure",
		"subtype": null,
		"stack": 10,
		"craftable": true,
		"level": 2,
		"recipe":[["wood", 20], ["stone", 20]],
		"description": "Used for more advanced cooking"
	},
	"target_dummy": {
		"icon": ICON_PATH + "target_dummy.png",
		"name": "Target Dummy",
		"type": "structure",
		"subtype": null,
		"stack": 10,
		"craftable": false,
		"level": 2,
		"recipe":[["wood", 20], ["stone", 20]],
		"description": "Used for target practice"
	},
	"bow": {
		"icon": ICON_PATH + "bow.png",
		"name": "Bow",
		"type": "weapon",
		"subtype": "bow",
		"stack": 1,
		"craftable": true,
		"level": 2,
		"recipe":[["wood", 20], ["fiber", 10]],
		"description": "Useful for ranged combat"
	},
	"arrow": {
		"icon": ICON_PATH + "arrow.png",
		"name": "Arrow",
		"type": "ammo",
		"subtype": "arrow",
		"stack": 50,
		"craftable": true,
		"level": 2,
		"recipe":[["wood", 5], ["fiber", 2], ["stone", 1]],
		"description": "Use with a bow"
	},
	"primitive_bomb": {
		"icon": ICON_PATH + "primitive_bomb.png",
		"name": "Primitive Bomb",
		"type": "weapon",
		"subtype": "bomb",
		"stack": 10,
		"craftable": true,
		"level": 99,
		"recipe": [],
		"description": "A makeshift explosive"
	},
	"lava_helmet": {
		"icon": ICON_PATH + "lava_helmet.png",
		"name": "Lava Helmet",
		"type": "armor",
		"subtype": "helmet",
		"stack": 1,
		"craftable": false
	},
	"lava_chest": {
		"icon": ICON_PATH + "lava_chest.png",
		"name": "Lava Chestpiece",
		"type": "armor",
		"subtype": "chest",
		"stack": 1,
		"craftable": false
	},
	"lava_legs": {
		"icon": ICON_PATH + "lava_legs.png",
		"name": "Lava Legs",
		"type": "armor",
		"subtype": "legs",
		"stack": 1,
		"craftable": false
	},
	"lava_gloves": {
		"icon": ICON_PATH + "lava_gloves.png",
		"name": "Lava Gloves",
		"type": "armor",
		"subtype": "gloves",
		"stack": 1,
		"craftable": false
	},
	"lava_boots": {
		"icon": ICON_PATH + "lava_boots.png",
		"name": "Lava Boots",
		"type": "armor",
		"subtype": "boots",
		"stack": 1,
		"craftable": false
	},
	"fiber": {
		"icon": ICON_PATH + "fiber.png",
		"type": "resource",
		"subtype": null,
		"stack": 100,
		"craftable": false
	},
	"apple": {
		"icon": ICON_PATH + "apple.png",
		"type": "food",
		"subtype": null,
		"stack": 10,
		"craftable": false
	},
	"berry": {
		"icon": ICON_PATH + "berry.png",
		"type": "food",
		"subtype": null,
		"stack": 10,
		"craftable": false
	},
	"fish": {
		"icon": ICON_PATH + "fish.png",
		"type": "food",
		"subtype": null,
		"stack": 10,
		"craftable": false
	},
	"wood": {
		"icon": ICON_PATH + "wood.png",
		"type": "resource",
		"subtype": null,
		"stack": 100,
		"craftable": false
	},
	"stone": {
		"icon": ICON_PATH + "stone.png",
		"type": "resource",
		"subtype": null,
		"stack": 100,
		"craftable": false
	},
	"obsidian": {
		"icon": ICON_PATH + "obsidian.png",
		"type": "resource",
		"subtype": null,
		"stack": 100,
		"craftable": false
	},
	"metal": {
		"icon": ICON_PATH + "metal.png",
		"type": "resource",
		"subtype": null,
		"stack": 100,
		"craftable": false
	},
	"null": {
		"icon": ICON_PATH + "null.png",
		"type": null,
		"subtype": null,
		"stack": 0,
		"craftable": false
	}
}

func get_item(item_id):
	if item_id in ITEMS:
		return ITEMS[item_id]
	else:
		return ITEMS["null"]
