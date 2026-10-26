extends Node3D

var message = '1934 Dust Bowl, again.'
@onready var sand = preload("res://scenes/sand.tscn")
@onready var spawn_range = GLOBALS.world.island_size/2

func _on_timer_timeout() -> void:
	queue_free()

func _on_timer_2_timeout() -> void:
	var sand_instance = sand.instantiate()
	sand_instance.position = Vector3(randf_range(-spawn_range,spawn_range),50,randf_range(-spawn_range,spawn_range))
	GLOBALS.world.add_child(sand_instance)
