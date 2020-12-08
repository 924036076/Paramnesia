extends EnemyCharacter

func end_attack_animation():
	can_attack = false
	attack_timer.start()
