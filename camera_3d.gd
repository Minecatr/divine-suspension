extends Camera3D

@export var shaking := false
@export var magnitude = 0.2

var initial_transform = transform 

func _process(_delta: float) -> void:
	if shaking:
		transform.origin = initial_transform.origin + Vector3(randf_range(-magnitude, magnitude),randf_range(-magnitude, magnitude),0.0)
	else:
		transform = initial_transform
		initial_transform = transform
