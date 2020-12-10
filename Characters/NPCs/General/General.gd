extends QuestCharacter

func define_missions():
	var mission1 = {
		"id": 1,
		"title": "Craft an axe",
		"description": "Gather wood and stone to craft an axe",
		"required": true,
		"prereqs": []
	}
	missions.append(mission1)
