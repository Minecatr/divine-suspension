extends RigidBody3D

var collide_damage = 50
@export var max_health:int=200
@onready var health = max_health
@onready var center = $Center
var effective_items = [
	'axe',
	'pickaxe'
]

func interact(item,damage_amount):
	if item in effective_items:
		damage(damage_amount)

func damage(amount):
	health -= amount
	if health <= 0:
		GLOBALS.spawn_drops('anvil',center.global_position)
		queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == 'Player' and linear_velocity.length() > 5:
		body.damage(collide_damage)
