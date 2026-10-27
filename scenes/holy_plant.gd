extends StaticBody3D

var max_health:int = 100
var health:int = 100
var grown:bool
#@onready var plant = preload("res://scenes/tree.tscn")

func _process(delta: float) -> void:
	if scale.y < 1:
		scale += Vector3.ONE * delta * 0.05
		#var tree_instance = tree.instantiate()
		#tree_instance.transform = transform
		#GLOBALS.world.add_child(tree_instance)
		#queue_free()
	else:
		grown = true

func damage():
	pass

func interact(_item,_damage):
	if grown:
		GLOBALS.spawn_drops('holy',$Center.global_position)
		scale = Vector3.ONE * 0.5
		grown = false
