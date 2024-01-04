extends CharacterBody2D


const SPEED = 100.0

@export var jump_max_height : float
@export var jump_min_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float
@export var max_jumps : int

@onready var jump_velocity : float = ((2.0 * jump_max_height) / jump_time_to_peak) * -1
@onready var jump_gravity : float = ((-2.0 * jump_max_height) / (jump_time_to_peak * jump_time_to_peak)) * -1
@onready var fall_gravity : float = ((-2.0 * jump_max_height) / (jump_time_to_descent * jump_time_to_descent)) * -1

#state
var is_jumping_requested: bool = false
var is_jumping : bool = false
var is_falling : bool = true
var jump_initial_position_y : float
var jump_count : int = 0

func _ready():
	$AnimatedSprite2D.play("idle")
	
func _process(delta):
	if is_jumping_requested:
		jump()
		is_jumping_requested = false

func _physics_process(delta):
	# Add the gravity.
	if is_jumping or is_falling:
		velocity.y += get_gravity() * delta
	velocity.x = get_input_velocity() * SPEED
	
	# do not delete
	# print(is_jumping, " | ", is_falling, " - ", velocity.y, " | ", jump_count, " | floor ", is_on_floor(), " - j reque ", is_jumping_requested)
	
	# If player is jumping, is still going up and player is not pressing the button
	if is_jumping and !Input.is_action_pressed("ui_jump") and velocity.y < 0:
		# If jump button is released and player is above min_jump_height, start falling
		if jump_initial_position_y - position.y > jump_min_height:
			velocity.y = 0
			
	if not is_on_floor() and velocity.y > 0:
		is_falling = true
		is_jumping = false

	if not is_on_floor() and velocity.y == 0:
		is_falling = true

	if is_on_floor():
		is_falling = false
		if velocity.y == 0:
			jump_count = 0

	move_and_slide()
	
func _input(event):
	if event.is_action_pressed("ui_jump") and jump_count < max_jumps:
		is_jumping_requested = true

func jump():
	jump_count += 1
	jump_initial_position_y = position.y
	is_jumping = true
	is_falling = false
	velocity.y = jump_velocity

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity
	
func get_input_velocity() -> float:
	var horizontal := 0.0
	
	if Input.is_action_pressed("ui_left"):
		$AnimatedSprite2D.play("idle")
		horizontal -= 1.0
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite2D.play("idle")
		horizontal += 1.0
	
	return horizontal