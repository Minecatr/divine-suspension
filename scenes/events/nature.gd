extends Node3D

var message = "Nature decides to run it's course."

func _ready() -> void:
	for i in range(randi_range(2,8)):
		GLOBALS.world.restore_nature()
