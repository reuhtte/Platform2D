extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -350.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_jumping = false
var is_falling = false
var is_landing = false

enum Direction {
	LEFT = -1,
	RIGHT = 1
}

var player_direction = Direction.RIGHT
	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# if keys are pressed it will return 1 for ui_right, -1 for ui_left, and 0 for neither
	var horizontal_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	# horizontal velocity which moves player left or right based on input
	if !is_landing:
		velocity.x = horizontal_input * SPEED
	else:
		velocity.x = 0
		
	if (Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")) and !is_jumping and !is_falling and !is_landing:
		$AnimatedSprite2D.play("run")
		
	if !Input.is_anything_pressed() and !is_jumping and !is_falling:
		$AnimatedSprite2D.play("idle")
		
	if velocity.y > 0 and !is_falling:
		$AnimatedSprite2D.play("fall")
		is_falling = true
		
	if is_falling and is_on_floor():
		$AnimatedSprite2D.play("landing")
		is_landing = true
		
	if velocity.x > 0:
		player_direction = Direction.RIGHT
		$AnimatedSprite2D.flip_h = false
		
	if velocity.x < 0:
		player_direction = Direction.LEFT
		$AnimatedSprite2D.flip_h = true

	move_and_slide()


func _input(event):
	if event.is_action_pressed("ui_jump") and !is_jumping:
		is_jumping = true
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("jump")

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "landing":
		is_landing = false
		is_falling = false
		is_jumping = false
