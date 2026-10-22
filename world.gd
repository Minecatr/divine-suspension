extends Node3D

@onready var cutscene_player = $AnimationPlayer
@onready var pause_menu = $CanvasLayer/PauseMenu

func _ready() -> void:
	GLOBALS.world = self
	cutscene_player.play('start')

func toggle_settings():
	pass

func toggle_pause():
	GLOBALS.paused = !GLOBALS.paused
	get_tree().paused = GLOBALS.paused
	pause_menu.visible = GLOBALS.paused
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if GLOBALS.paused else Input.MOUSE_MODE_CAPTURED

func quit():
	get_tree().quit()
