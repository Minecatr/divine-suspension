extends Node3D

var message = 'The floor is lava in 3.'
var damaging = false
var attack_damage := 3
var time = 2
var player:CharacterBody3D

func _on_timer_2_timeout() -> void:
	queue_free()


func _on_timer_timeout() -> void:
	if time > 0:
		GLOBALS.world.create_message('The floor is lava in '+str(time)+'.')
		time -= 1
		$CountDownTimer.start()
	else:
		$MeshInstance3D.show()
		damaging = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == 'Player':
		player = body


func _on_timer_3_timeout() -> void:
	if player and damaging:
		player.damage(attack_damage)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == player:
		player = null
