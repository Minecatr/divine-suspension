class_name GLOBALS

static var world:Node
static var paused:bool = false

static func interpret(id) -> PackedScene:
	return load('res://scenes/'+id+'.tscn')

static var recipe_sets: Dictionary = {
	'plot': [
		{'id': 'crafting_table', 'ingredients': ['log']},
		{'id': 'furnace', 'ingredients': ['stone', 'stone']},
	],
	'crafting_table': [
		{'id': 'axe', 'ingredients': ['stick', 'stone']},
		{'id': 'hammer', 'ingredients': ['stick', 'log']},
		{'id': 'wall', 'ingredients': ['log']},
	],
	'furnace': [
		{'id': 'coal', 'ingredients': ['log']},
		{'id': 'steel', 'ingredients': ['coal','iron']}
	]
}

static var loot_tables: Dictionary = {
	'tree': [
		{'item': 'log', 'chance': 1.0, 'min': 2, 'max': 4},
		{'item': 'stick', 'chance': 0.5, 'min': 1, 'max': 2},
		{'item': 'acorn', 'chance': 1.0, 'min': 1, 'max': 2}
	],
	'rock': [
		{'item': 'stone', 'chance': 1.0, 'min': 2, 'max': 4},
		{'item': 'iron', 'chance': 0.2, 'min': 1, 'max': 1},
	],
	'wall': [
		{'item': 'wall', 'chance': 1.0, 'min': 1, 'max': 1},
	],
}
static func _static_init() -> void:
	for recipe in recipe_sets["plot"]:
		var table: Array = []
		for ingredient in recipe["ingredients"]:
			table.append({"item": ingredient, "chance": 1.0, "min": 1, "max": 1})
		loot_tables[recipe["id"]] = table

static func spawn_drops(id: String, at: Vector3) -> void:
	for entry in loot_tables[id]:
		if randf() > entry.get('chance', 1.0):
			continue
		var scene := interpret(entry['item'])
		if scene == null:
			continue
		for i in randi_range(entry.get('min', 1), entry.get('max', 1)):
			var drop = scene.instantiate()
			world.add_child(drop)
			drop.global_position = at
			drop.apply_torque_impulse(Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1)))
			drop.apply_impulse(Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1)))
