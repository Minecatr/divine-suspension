extends RigidBody3D

@export var id = 'anvil'
@export var message = 'Meteor incoming!'
var collide_damage = 50 
@export var max_health:int=200
@onready var health = max_health
@onready var center = $Center
@onready var spawn_range = GLOBALS.world.island_size/2
var effective_items = [
	'axe',
	'pickaxe'
]

func _ready() -> void:
	position = Vector3(randf_range(-spawn_range,spawn_range),50,randf_range(-spawn_range,spawn_range))
	if id == 'meteor':
		scale = Vector3.ONE * randf_range(0.5,3)

func interact(item,damage_amount):
	if item in effective_items:
		damage(damage_amount)

func damage(amount):
	health -= amount
	if health <= 0:
		GLOBALS.spawn_drops(id,center.global_position)
		queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == 'Player' and linear_velocity.length() > 5:
		body.damage(collide_damage)
