extends CharacterBody2D

@export var speed = 100
@export var dash_speed = 150
@export var gravity = 200
@export var jump_height = -100
var is_attacking = false
var is_jumping = false
var is_dashing = false

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
	if is_dashing:
		velocity.x = player_direction * dash_speed
	elif is_attacking:
		velocity.x = 0	
	else:
		# if keys are pressed it will return 1 for ui_right, -1 for ui_left, and 0 for neither
		var horizontal_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		# horizontal velocity which moves player left or right based on input
		velocity.x = horizontal_input * speed

func player_animations():
	if Input.is_action_pressed("ui_move_left") and !is_attacking and !is_jumping and !is_dashing:
		$AnimatedSprite2D.play("run")
		$CollisionShape2D.position.x = 7
		
	if Input.is_action_pressed("ui_move_right") and !is_attacking and !is_jumping and !is_dashing:
		$AnimatedSprite2D.play("run")
		$CollisionShape2D.position.x = -7
		
	if !Input.is_anything_pressed() and !is_attacking and !is_jumping and !is_dashing:
		$AnimatedSprite2D.play("idle")
		
	if velocity.y < 0:
		$AnimatedSprite2D.play("jump")
		
	if velocity.y > 0:
		$AnimatedSprite2D.play("fall")
		
	if velocity.x > 0:
		print("caminando")
		player_direction = Direction.RIGHT
		$AnimatedSprite2D.flip_h = false
		
	if velocity.x < 0:
		player_direction = Direction.LEFT
		$AnimatedSprite2D.flip_h = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# vertical movement velocity (down)
	velocity.y += gravity * delta
	
	#if is_attacking or is_dashing:
	#	return
	
	# horizontal movement processing (left, right)
	horizontal_movement()
	
	# applies movement
	move_and_slide()
	
	player_animations()
	
	if is_on_floor():
		is_jumping = false
		
	
	
func _input(event):
	#on attack
	if event.is_action_pressed("ui_attack") and !is_jumping and !is_dashing:
		is_attacking = true
		$AnimatedSprite2D.play("attack")
		
	if event.is_action_pressed("ui_attack") and !is_jumping and is_dashing:
		is_attacking = true
		$AnimatedSprite2D.play("dash_attack")
	
	#on jump
	if event.is_action_pressed("ui_jump") and is_on_floor():
		is_jumping = true
		velocity.y = jump_height
		$AnimatedSprite2D.play("jump")
	
	if event.is_action_pressed("ui_dash") and !is_dashing and is_on_floor():
		is_dashing = true
		#velocity.x = dash_speed	
		$AnimatedSprite2D.play("dash")

func _on_animated_sprite_2d_animation_finished():
	# print(anim_name)
	print("termino animacion")
	
	## if anim_name == "attack":
	is_attacking = false
	is_dashing = false
	## if anim_name == "dash":
	##	is_dashing = false	
	
	
