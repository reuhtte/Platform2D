extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -400.0

enum Direction {
	LEFT = -1,
	RIGHT = 1
}

var enemy_direction = Direction.RIGHT


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
	distance_traveled += SPEED
	
	if distance_traveled > 5000:
		enemy_direction *= -1
		distance_traveled = 0
		
	
	print("position x ", velocity.x)
	print("distance ", distance_traveled)
	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if is_on_floor():
		patrol(delta)
		
	enemy_animations()

	move_and_slide()
