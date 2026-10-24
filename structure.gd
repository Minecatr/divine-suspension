extends StaticBody3D

@onready var center = $Center

@export var crafting_tools:Array[String]=['']
@export var destroy_tools:Array[String]=['hammer']
@export var id:String

var items:Array

func interact(tool):
	if GLOBALS.recipe_sets.has(id) and tool in crafting_tools:
		for recipe in GLOBALS.recipe_sets[id]:
			var recipe_filtered:Array=recipe.ingredients.duplicate()
			var used_items:Array=[]
			for item in items:
				if item.id in recipe_filtered:
					recipe_filtered.erase(item.id)
					used_items.append(item)
			if recipe_filtered.size() <= 0:
				for item in used_items:
					item.queue_free()
				var result = load("res://scenes/"+recipe.id+".tscn").instantiate()
				result.position = $Area3D.global_position
				result.rotation = global_rotation
				get_parent().add_child(result)
				break
	if tool in destroy_tools:
		if GLOBALS.loot_tables.has(id):
			GLOBALS.spawn_drops(id,center.global_position)
		queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group('item'):
		items.append(body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group('item'):
		items.erase(body)
