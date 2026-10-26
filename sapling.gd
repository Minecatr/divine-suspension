extends StaticBody3D

@onready var tree = preload("res://scenes/tree.tscn")

func _process(delta: float) -> void:
	scale += Vector3.ONE * delta * 0.01
	if scale.y > 1:
		var tree_instance = tree.instantiate()
		tree_instance.transform = transform
		GLOBALS.world.add_child(tree_instance)
		queue_free()
