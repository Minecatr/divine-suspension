extends RayCast3D

const DAMAGE = 5
func damage_parent():
	if not is_colliding():
		get_parent().damage(5)


func _on_grace_timeout() -> void:
	GLOBALS.world.acid_tick.connect(damage_parent)
