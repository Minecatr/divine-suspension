extends Node3D

var message = 'Anvils are falling from the sky.'
@onready var anvil = preload("res://anvil.tscn")
@onready var spawn_range = GLOBALS.world.island_size/2

func _on_timer_timeout() -> void:
	queue_free()

func _on_timer_2_timeout() -> void:
	var anvil_instance = anvil.instantiate()
	anvil_instance.position = Vector3(randf_range(-spawn_range,spawn_range),50,randf_range(-spawn_range,spawn_range))
	GLOBALS.world.add_child(anvil_instance)
