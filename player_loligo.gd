extends CharacterBody2D


const SPEED = 100.0

@export var jump_max_height : float
@export var jump_min_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = ((2.0 * jump_max_height) / jump_time_to_peak) * -1
@onready var jump_gravity : float = ((-2.0 * jump_max_height) / (jump_time_to_peak * jump_time_to_peak)) * -1
@onready var fall_gravity : float = ((-2.0 * jump_max_height) / (jump_time_to_descent * jump_time_to_descent)) * -1

#state
var is_jumping : bool = false
var jump_initial_position_y : float

func _ready():
	$AnimatedSprite2D.play("idle")

func _physics_process(delta):
	# Add the gravity.
	velocity.y += get_gravity() * delta
	velocity.x = get_input_velocity() * SPEED
	
	# If player is jumping, is still going up and player is not pressing the button
	if is_jumping and !Input.is_action_pressed("ui_jump") and velocity.y < 0:
		# If jump button is released and player is above min_jump_height, start falling
		if jump_initial_position_y - position.y > jump_min_height:
			is_jumping = false
			velocity.y = 0

	move_and_slide()
	
func _input(event):
	if event.is_action_pressed("ui_jump") and is_on_floor():
		jump()

func jump():
	jump_initial_position_y = position.y
	is_jumping = true
	velocity.y = jump_velocity

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity
	
func get_input_velocity() -> float:
	var horizontal := 0.0
	
	if Input.is_action_pressed("ui_left"):
		$AnimatedSprite2D.play("walk")
		horizontal -= 1.0
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite2D.play("walk")
		horizontal += 1.0
	
	return horizontal
