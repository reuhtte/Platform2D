extends Node

enum Levels {
	LEVEL_01_ROOM_LOLIGO,
	LEVEL_01_ROOM_PARCHI,
	LEVEL_01_HOUSE
}

var game_levels_scenes = {
	Levels.LEVEL_01_ROOM_LOLIGO: "res://levels/level_01/room_loligo.tscn",
	Levels.LEVEL_01_ROOM_PARCHI: "res://levels/level_01/room_parchi.tscn",
	Levels.LEVEL_01_HOUSE: "res://levels/level_01/house.tscn"
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
