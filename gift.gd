extends RigidBody3D

var max_health = 50
@onready var health = max_health

var items = [
	'acorn',
	'axe',
	'coal',
	'hammer',
	'iron',
	'log',
	'steel',
	'stick',
	'stone',
	'berry',
	'pickaxe',
	'sand'
]

func interact(_item,damage_amount):
	apply_central_impulse(Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1)))
	apply_torque_impulse(Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1)))
	damage(damage_amount)
func damage(amount):
	health -= amount
	if health <= 0:
		var new_item = load("res://scenes/"+items.pick_random()+".tscn").instantiate()
		new_item.transform = transform
		GLOBALS.world.add_child(new_item)
		queue_free()
func _physics_process(_delta: float) -> void:
	if global_position.y < GLOBALS.death_height:
		GLOBALS.world.consume('gift')
		queue_free()
