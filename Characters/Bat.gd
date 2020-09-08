extends KinematicBody2D

const DeathEffect = preload("res://Effects/EnemyDeath.tscn")

export var ACCELERATION = 200
export var MAX_SPEED = 50
export var FRICTION = 200

enum {
	IDLE,
	WANDER,
	CHASE
}
var state = IDLE

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
onready var stats = get_node("Stats")
onready var healthbar = get_node("SmallHealthbar")
onready var playerDetection = get_node("DetectionZone")
onready var sprite = get_node("AnimatedSprite")
onready var hurtbox = get_node("Hurtbox")
onready var soft_collision = get_node("SoftCollision")
onready var wander = get_node("Wander")

func _ready():
	healthbar.max_value = stats.max_health
	healthbar.value = stats.health
	state = pick_random_state([IDLE, WANDER])

func seek_player():
	if playerDetection.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
			seek_player()
			if wander.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wander.start_wander_timer(rand_range(1, 3))
		WANDER:
			seek_player()
			if wander.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wander.start_wander_timer(rand_range(1, 3))
				
			var direction = global_position.direction_to(wander.target_position)
			velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			sprite.flip_h = velocity.x < 0
			
			if global_position.distance_to(wander.target_position) <= MAX_SPEED * 0.1:
				state = pick_random_state([IDLE, WANDER])
				wander.start_wander_timer(rand_range(1, 3))
		CHASE:
			var player = playerDetection.player
			if player != null:
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				sprite.flip_h = velocity.x < 0
			else:
				state = IDLE
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * 100
	velocity = move_and_slide(velocity)
	
func _on_Hurtbox_area_entered(area):
	knockback = area.knockback_vector * 100
	stats.health -= PlayerData.damage
	healthbar.value = stats.health
	healthbar.show()
	hurtbox.start_invicibility(0.5)

func _on_Stats_no_health():
	var deathEffect = DeathEffect.instance()
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position
	queue_free()
