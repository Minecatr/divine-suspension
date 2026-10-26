extends Node3D

var message = "It's national river rising day!"

func _process(delta: float) -> void:
	position.y += delta*0.1
	if not GLOBALS.world.get_node('Player') in $Area3D.get_overlapping_bodies():
		$CanvasLayer/Panel.show()
	else:
		$CanvasLayer/Panel.hide()

func _on_despawn_timer_timeout() -> void:
	queue_free()


func _on_damage_timer_timeout() -> void:
	if not GLOBALS.world.get_node('Player') in $Area3D.get_overlapping_bodies():
		GLOBALS.world.get_node('Player').damage(1)
