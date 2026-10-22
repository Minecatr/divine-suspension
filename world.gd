extends Node3D

@onready var cutscene_player = $AnimationPlayer

func _ready() -> void:
	cutscene_player.play('start')
