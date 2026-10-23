extends CharacterBody3D

@export var SPEED := 5.0
@export var JUMP_VELOCITY := 4.0
@export var ACCELERATION := 10.0
@export var AIR_ACCELERATION := 2.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var jumping = false
var object

var input_rotation: Vector3
var mouse_input: Vector2
var mouse_sensitivity: float = 0.002

var use_interpolation: bool = false
var circle_strafe: bool = true

@onready var interact :RayCast3D= $Camera3D/Interact
@onready var indicator = $Indicator
@onready var camera = $Camera3D
@onready var animation_player = $AnimationPlayer
@onready var hand = camera.get_node("Hand")
@onready var back = $Back
var held_item : RigidBody3D
var stored_item : RigidBody3D

func _force_update_is_on_floor() -> void:
	var old_velocity := velocity
	velocity = Vector3.ZERO
	move_and_slide()
	velocity = old_velocity

func _physics_process(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	jumping = Input.is_action_pressed("jump")
	
	_force_update_is_on_floor()
	var acceleration := ACCELERATION if is_on_floor() else AIR_ACCELERATION
	var speed := SPEED
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y).normalized()).normalized()
	var target_velocity := direction * speed
	
	#mouse_rotation_amount_hack = 0
	if !is_on_floor():
		velocity.y -= gravity * delta
	if is_on_floor() and jumping:
		velocity.y = JUMP_VELOCITY

	velocity = Vector3(
		lerp(velocity.x, target_velocity.x, delta * acceleration),
		velocity.y,
		lerp(velocity.z, target_velocity.z, delta * acceleration))
	
	#velocity *= delta
	move_and_slide()
	#velocity /= delta

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_input.x += -event.screen_relative.x * mouse_sensitivity
		mouse_input.y += -event.screen_relative.y * mouse_sensitivity

func _process(_delta: float) -> void:
	input_rotation.x = clampf(input_rotation.x + mouse_input.y, deg_to_rad(-90), deg_to_rad(85))
	input_rotation.y += mouse_input.x
	# rotate camera controller (up/down)
	#camera.transform.basis = Basis.from_euler(Vector3(input_rotation.x, 0.0, 0.0))
	# rotate player (left/right)
	global_transform.basis = Basis.from_euler(Vector3(input_rotation.x, input_rotation.y, 0.0))
	#global_transform = camera_controller_anchor.get_global_transform_interpolated()
	mouse_input = Vector2.ZERO
	
	
	
	if interact.is_colliding():
		object = interact.get_collider()
		indicator.show()
		if object and (object.is_in_group('interactable') or object.is_in_group('item')):
			indicator.global_position = interact.get_collider().get_node('Center').global_position
		elif held_item and held_item.structure:
			indicator.global_position = (interact.get_collision_point()*2).round()/2
		else:
			indicator.hide()
	else:
		indicator.hide()

	if Input.is_action_just_pressed("interact"):
		
		animation_player.play("swing")
		if not interact.get_collider(): return
		if object.is_in_group('interactable'):
			object.interact(held_item.id if held_item else '')
		elif object.is_in_group('item') and not held_item:
			object.reparent(hand)
			object.position = Vector3.ZERO
			object.rotation = Vector3.ZERO
			object.freeze = true
			held_item = object
		elif held_item:
			if held_item.structure and object.is_in_group('map'):
				var structure_instance = held_item.structure.instantiate()
				structure_instance.position = indicator.global_position
				structure_instance.rotation_degrees.y = 45*round(rotation_degrees.y/45)+180
				GLOBALS.world.add_child(structure_instance)
				if held_item.consumable:
					held_item.queue_free()

	
	if Input.is_action_just_pressed("drop") and held_item:
		held_item.freeze = false
		held_item.reparent(get_parent())
		held_item = null
	if Input.is_action_just_pressed('store'):
		if stored_item:
			stored_item.reparent(hand)
			stored_item.position = Vector3.ZERO
			stored_item.rotation = Vector3.ZERO
		if held_item:
			held_item.reparent(back)
			held_item.position = Vector3.ZERO
			held_item.rotation = Vector3.ZERO
		stored_item = back.get_child(0)
		held_item = hand.get_child(0)
