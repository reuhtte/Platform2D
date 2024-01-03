extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -400.0

enum Direction {
	LEFT = -1,
	RIGHT = 1
}

var enemy_direction = Direction.RIGHT

const CHASING_SPEED = 100
var is_chasing = false

var player = null


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var distance_traveled = 0

func enemy_animations():
	$AnimatedSprite2D.play("idle")
	
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	
func patrol(delta):
	velocity.x = enemy_direction * SPEED
	
	if !is_chasing:
		distance_traveled += SPEED
	
	if distance_traveled > 5000 and !is_chasing:
		enemy_direction *= -1
		distance_traveled = 0
		
	
	#print("position x ", velocity.x)
	#print("distance ", distance_traveled)

func move_towards_player(delta):
	# Find the player
	if player:
		velocity.x = position.direction_to(player.position).x * CHASING_SPEED
		#print("position y ", position.direction_to(player.position).y)
	else:
		is_chasing = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if is_chasing:
		# Chase the player
		move_towards_player(delta)
	else:
		# Patrol within the restricted zone
		patrol(delta)
		
	#if is_on_floor():
	#	patrol(delta)
		
	enemy_animations()

	move_and_slide()


func _on_area_2d_body_entered(body):
	player = body
	is_chasing = true

func _on_area_2d_body_exited(body):
	player = null
