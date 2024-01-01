extends CanvasLayer

var next_scene = preload("res://Main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("start_button"):
		get_tree().change_scene_to_packed(next_scene)
