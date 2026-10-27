extends StaticBody3D

@onready var center = $Center

@export var crafting_tools:Array[String]=['']
@export var destroy_tools:Array[String]=['hammer']
@export var id:String

@export var max_health:int=0
@onready var health = max_health
@onready var acid_cast = preload("res://scenes/events/acid_cast.tscn")

var items:Array


func _ready() -> void:
	if id != 'crafting_table':
		add_child(acid_cast.instantiate())

func interact(tool,damage_amount):
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
		damage(damage_amount)

func damage(amount):
	health -= amount
	if health <= 0:
		if GLOBALS.loot_tables.has(id):
			GLOBALS.spawn_drops(id,center.global_position)
		queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group('item'):
		items.append(body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group('item'):
		items.erase(body)
