extends Node3D

var message = 'An army of crows is approaching.'
@onready var crow = preload("res://crow.tscn")

func _ready() -> void:
	var close = GLOBALS.world.island_size*3
	var far = close*2
	position = Vector3(0,5,0) + (Vector3.FORWARD.rotated(Vector3.UP,randf()*TAU)*randf_range(close,far))
	var crows = randi_range(3,9)
	for i in crows:
		var crow_instance = crow.instantiate()
		crow_instance.position = position + Vector3(randf_range(-2,2),randf_range(-2,2),randf_range(-2,2))
		GLOBALS.world.add_child(crow_instance)

func _on_timer_timeout() -> void:
	queue_free()
