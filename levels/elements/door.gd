extends Area2D

@export var next_scene : PackedScene:
	get:
		return next_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	print("loligo está en puerta", self.get_class())
	body.door = self.next_scene.resource_path

func _on_body_exited(body):
	print("loligo salió de puerta")
	body.door = ""
