extends Label

func _ready() -> void:
	pivot_offset = size/2
func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
