extends EnemyCharacter

const Arrow = preload("res://Characters/NPCs/Skeleton/Archer/Arrow.tscn")

func attack():
	animationState.travel("Attack")

func create_arrow():
	can_attack = false
	attack_timer.start()
	var arrow = Arrow.instance()
	arrow.global_position = get_node("ArrowSpawn").global_position
	var arrow_dir = global_position.direction_to(nearest_enemy.global_position)
	arrow.rotate(arrow_dir.angle())
	arrow.direction = arrow_dir
	get_parent().add_child(arrow)

func _on_AttackCooldown_timeout():
	can_attack = true
