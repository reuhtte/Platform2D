extends CharacterBody2D

@export var speed = 100
@export var dash_speed = 200
@export var dash_attack_speed = 50
@export var slide_speed = 150
@export var gravity = 200
@export var jump_height = -100
@export var max_jumps = 2

var is_attacking = false
var is_jumping = false
var jump_count = 0
var is_dashing = false
var is_crouching = false
var is_sliding = false

enum Direction {
	LEFT = -1,
	RIGHT = 1
}

var player_direction = Direction.RIGHT


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#horizontal movement calculation
func horizontal_movement():
	if is_dashing and !is_attacking:
		velocity.x = player_direction * dash_speed
	elif is_dashing and is_attacking:
		velocity.x = player_direction * dash_attack_speed
	elif is_attacking and !is_dashing:
		velocity.x = 0
	elif is_sliding:
		velocity.x = player_direction * slide_speed
	else:
		# if keys are pressed it will return 1 for ui_right, -1 for ui_left, and 0 for neither
		var horizontal_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		# horizontal velocity which moves player left or right based on input
		velocity.x = horizontal_input * speed

func player_animations():
	if Input.is_action_pressed("ui_move_left") and !is_attacking and !is_jumping and !is_dashing and !is_sliding:
		$AnimatedSprite2D.play("run")
		$CollisionShape2D.position.x = 7
		
	if Input.is_action_pressed("ui_move_right") and !is_attacking and !is_jumping and !is_dashing and !is_sliding:
		$AnimatedSprite2D.play("run")
		$CollisionShape2D.position.x = -7
		
	if !Input.is_anything_pressed() and !is_attacking and !is_jumping and !is_dashing and !is_sliding:
		$AnimatedSprite2D.play("idle")
		
	if Input.is_action_pressed("ui_down") and !is_crouching and !is_sliding:
		is_crouching = true
		$AnimatedSprite2D.play("crouch_down")
	elif Input.is_action_just_released("ui_down") and is_crouching and !is_sliding:
		is_crouching = false
		$AnimatedSprite2D.play("crouch_up")
	
	if is_crouching and !is_sliding:
		$AnimatedSprite2D.play("crouch_idle")
		
	if velocity.y < 0:
		$AnimatedSprite2D.play("jump")
		
	if velocity.y > 0:
		$AnimatedSprite2D.play("fall")
		
	if velocity.x > 0:
		player_direction = Direction.RIGHT
		$AnimatedSprite2D.flip_h = false
		
	if velocity.x < 0:
		player_direction = Direction.LEFT
		$AnimatedSprite2D.flip_h = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# vertical movement velocity (down)
	velocity.y += gravity * delta
	
	print("is_attacking ", is_attacking)
	# horizontal movement processing (left, right)
	horizontal_movement()
	
	# applies movement
	move_and_slide()
	
	player_animations()
	
	if is_on_floor():
		jump_count = 0
		is_jumping = false
		
	
	
func _input(event):
	#on attack
	if event.is_action_pressed("ui_attack") and !is_jumping and !is_dashing and !is_sliding and !is_crouching:
		is_attacking = true
		$AnimatedSprite2D.play("attack")
		
	if event.is_action_pressed("ui_attack") and !is_jumping and is_dashing and !is_sliding and !is_crouching:
		is_attacking = true
		$AnimatedSprite2D.play("dash_attack")
	
	#on jump
	if event.is_action_pressed("ui_jump") and jump_count < max_jumps and !is_crouching and !is_attacking:
		jump_count += 1
		is_jumping = true
		is_dashing = false
		is_crouching = false
		velocity.y = jump_height
		$AnimatedSprite2D.play("jump")
		
	if event.is_action_pressed("ui_jump") and is_crouching and !is_attacking:
		is_sliding = true
		is_dashing = false
		is_jumping = false
		$AnimatedSprite2D.play("slide")
	
	if event.is_action_pressed("ui_dash") and !is_dashing and is_on_floor() and !is_crouching:
		is_dashing = true
		is_sliding = false
		is_jumping = false
		$AnimatedSprite2D.play("dash")

func _on_animated_sprite_2d_animation_finished():
	print("animation ", $AnimatedSprite2D.animation)
	if $AnimatedSprite2D.animation == "attack" or $AnimatedSprite2D.animation == "dash_attack":
		is_attacking = false
	if $AnimatedSprite2D.animation == "dash" or $AnimatedSprite2D.animation == "dash_attack":
		is_dashing = false
	if $AnimatedSprite2D.animation == "slide":
		is_sliding = false
		is_crouching = false
