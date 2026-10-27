extends Node3D

var message := 'It shall now acid rain!'
@onready var particles := $GPUParticles3D

func _process(_delta: float) -> void:
	particles.position = GLOBALS.world.get_node('Player').position + Vector3(0, 3, 0)

func _on_hit_timer_timeout() -> void:
	GLOBALS.world.emit_signal('acid_tick')


func _on_timer_timeout() -> void:
	queue_free()
