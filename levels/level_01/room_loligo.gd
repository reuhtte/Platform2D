extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("camera")
	# To stop player from moving
	$PlayerLoligo.set_physics_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "camera":
		# Let player move after animation is finished
		$PlayerLoligo.set_physics_process(true)
		
