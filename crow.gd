extends CharacterBody3D

const SPEED := 150.0
@export var ACCELERATION := 1.0

@onready var animation_player = $AnimationPlayer
var attacking:=false
const DAMAGE := 5
var max_health := 10
var gravity := 0
var dead := false
@onready var health := max_health


func interact(_item,damage_amount):
	damage(damage_amount)

func damage(amount):
	health -= amount
	if health <= 0:
		dead = true
		motion_mode = CharacterBody3D.MOTION_MODE_GROUNDED
		gravity = 10
		animation_player.play('death')

func _physics_process(delta: float) -> void:
	var player =GLOBALS.world.get_node('Player')
	
	if not dead:
		look_at(player.position)
		velocity = Vector3.ZERO
		if not attacking:
			var distance = position.distance_to(player.position)
			if distance > 1.5:
				velocity = lerp(velocity, transform.basis.z * -SPEED, delta * ACCELERATION)
			else:
				animation_player.play('attack')
				attacking = true
	velocity.y -= gravity * delta
	move_and_slide()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		'attack':
			attacking = false
		'death':
			queue_free()
