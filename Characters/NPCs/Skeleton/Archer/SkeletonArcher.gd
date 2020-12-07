extends EnemyCharacter

const Arrow = preload("res://Characters/NPCs/Skeleton/Archer/Arrow.tscn")

var can_spawn_arrow = true

func attack():
	if can_attack:
		animationState.travel("Attack")
	else:
		animationState.travel("IdleWeapon")

func create_arrow():
	if can_spawn_arrow:
		can_spawn_arrow = false
		var arrow = Arrow.instance()
		arrow.global_position = global_position
		var arrow_dir = global_position.direction_to(nearest_enemy.global_position)
		arrow.rotate(arrow_dir.angle())
		arrow.direction = arrow_dir
		get_parent().add_child(arrow)

func _on_AttackCooldown_timeout():
	can_attack = true
	can_spawn_arrow = true

func end_attack_animation():
	can_attack = false
	attack_timer.start()
