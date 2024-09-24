extends Area2D

func _on_body_entered(_body: Player) -> void:
	call_deferred("reset_level")

func reset_level():
	get_tree().reload_current_scene()
