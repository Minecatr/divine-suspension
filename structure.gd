extends StaticBody3D

@onready var center = $Center

@export var crafting_items:Array[String]
@export var destroy_items:Array[String]
@export var results:Array[String]

@export var recipes : Array[Recipe]

var items:Array

func interact(tool):
	if recipes.size() > 0 and (crafting_items.size()<=0 or tool in crafting_items):
		for recipe in recipes:
			var recipe_filtered:Array=recipe.ingredients.duplicate()
			var used_items:Array=[]
			for item in items:
				if item.id in recipe_filtered:
					recipe_filtered.erase(item.id)
					used_items.append(item)
			if recipe_filtered.size() <= 0:
				for item in used_items:
					item.queue_free()
				var result = load("res://scenes/"+recipe.result+".tscn").instantiate()
				result.position = $Area3D.global_position
				result.rotation = global_rotation
				get_parent().add_child(result)
				break
	if tool in destroy_items:
		if results.size() > 0:
			for result in results:
				var result_instance:RigidBody3D=load("res://scenes/"+result+".tscn").instantiate()
				result_instance.position = center.global_position
				GLOBALS.world.add_child(result_instance)
				result_instance.apply_torque_impulse(Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1)))
				result_instance.apply_impulse(Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1)))
		queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group('item'):
		items.append(body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group('item'):
		items.erase(body)
