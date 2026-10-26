extends Node3D

@onready var cutscene_player = $AnimationPlayer
@onready var pause_menu = $CanvasLayer/PauseMenu
@onready var health_bar = $CanvasLayer/HUD/ProgressBar
@onready var hud = $CanvasLayer/HUD
@onready var message = preload("res://message.tscn")
@onready var gift = preload("res://gift.tscn")
var features = [
	preload('res://scenes/sapling.tscn'),
	preload('res://scenes/rock.tscn'),
	preload('res://scenes/bush.tscn')
]
var events = {
	preload('res://scenes/events/crows.tscn'): 15.0,
	preload('res://scenes/events/anvils.tscn'): 15.0,
	preload('res://scenes/events/lava_floor.tscn'): 15.0,
	preload("res://scenes/events/flood.tscn"): 15.0,
	preload("res://scenes/events/sandstorm.tscn"): 0.0
}
var elapsed:float
var island_size:float=4.0

var consumed_items:Dictionary[String, int]
var score := 0

func _ready() -> void:
	GLOBALS.world = self
	GLOBALS.health_bar = health_bar
	update_island_size()
	cutscene_player.play('start')
	create_message('How dare you step on a crack!')

func consume(id):
	if not consumed_items.has(id):
		consumed_items[id] = 1
	else:
		consumed_items[id] += 1
	var new_score := 0.0
	for amount in consumed_items.values():
		new_score += pow(float(amount),0.75)
	if (new_score - score) > 2: # BLESS FACTOR
		score += 3
		create_message('You have been blessed!')
		match randi_range(0,2):
			0:
				var gift_instance = gift.instantiate()
				var spawn_range = island_size/4.0
				gift_instance.position = Vector3(randf_range(-spawn_range,spawn_range),20,randf_range(-spawn_range,spawn_range))
				add_child(gift_instance)
			1:
				island_size+=1.0
				update_island_size()
			2:
				var feature_instance = features.pick_random().instantiate()
				var spawn_range = island_size - 1.0
				feature_instance.position = Vector3(randi_range(-spawn_range,spawn_range)/2.0,1,randi_range(-spawn_range,spawn_range)/2.0)
				add_child(feature_instance)

func toggle_settings():
	pass

func update_island_size():
	$Platform/CollisionShape3D.shape.size.x = island_size
	$Platform/CollisionShape3D.shape.size.z = island_size
	$Platform/MeshInstance3D3.mesh.size.x = island_size
	$Platform/MeshInstance3D3.mesh.size.z = island_size
	$Platform/MeshInstance3D.mesh.size.x = island_size
	$Platform/MeshInstance3D.mesh.size.z = island_size

func toggle_pause():
	GLOBALS.paused = !GLOBALS.paused
	get_tree().paused = GLOBALS.paused
	pause_menu.visible = GLOBALS.paused
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if GLOBALS.paused else Input.MOUSE_MODE_CAPTURED

func quit():
	get_tree().quit()

func create_message(text):
	var new_message = message.instantiate()
	new_message.text = text
	new_message.get_node('AnimationPlayer').play('start')
	hud.add_child(new_message)

func _process(delta: float) -> void:
	elapsed += delta

func _on_timer_timeout() -> void:
	var valid = events.keys().filter(func(k): return events[k] <= elapsed)
	var new_event = valid.pick_random().instantiate()
	create_message(new_event.message)
	add_child(new_event)


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	$Timer.start()
	elapsed = 0
