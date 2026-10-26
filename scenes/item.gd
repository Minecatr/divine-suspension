extends RigidBody3D

@export var id:String = 'unknown'
@export var consumable:bool = false
@export var structure:PackedScene
@export var damage:=10
@export var heal_amount:=0

func _physics_process(_delta: float) -> void:
	if global_position.y < GLOBALS.death_height:
		GLOBALS.world.consume(id)
		queue_free()
