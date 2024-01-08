extends Area2D

@export var next_scene : SceneManager.Levels

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(body):
	print("loligo está en puerta", self.get_class())
	body.door = SceneManager.game_levels_scenes[next_scene]

func _on_body_exited(body):
	print("loligo salió de puerta")
	body.door = ""
