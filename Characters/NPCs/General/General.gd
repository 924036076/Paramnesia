extends QuestCharacter

func define_missions():
	var mission1 = {
		"id": 1,
		"title": "Craft an axe",
		"description": "Gather wood and stone to craft an axe",
		"required": true,
		"prereqs": [],
		"start_dialogue": ["We've run out of axes in our stores. Can you forage for materials around camp and", "craft a stone axe?"],
		"type": "item",
		"item_list": [["stone_axe", 1]],
		"reward": "item",
		"reward_items": [["wood", 20], ["stone", 20]]
	}
	missions.append(mission1)
