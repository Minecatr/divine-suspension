extends StaticBody3D

@onready var area = $Area3D

@export var recipes : Array[Array]= [
	[load("res://scenes/items/axe.tscn"), ['stick','stick','rock']]
]

var items:Array

func interact():
	print(items)
	for recipe in recipes:
		var recipe_filtered:Array=recipe[1].duplicate()
		var used_items:Array=[]
		for item in items:
			if item.id in recipe_filtered:
				recipe_filtered.erase(item.id)
				used_items.append(item)
		if recipe_filtered.size() <= 0:
			for item in used_items:
				item.queue_free()
			
			var result = recipe[0].instantiate()
			result.position = area.global_position
			get_parent().add_child(result)
			return



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group('item'):
		items.append(body)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group('item'):
		items.erase(body)
