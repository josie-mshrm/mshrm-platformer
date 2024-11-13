class_name WallState
extends MoveState

func _update(delta: float) -> void:
	host.move_character_x(delta, x_mod)
	
	if not soul.is_on_wall_only():
		if soul.is_on_floor():
			dispatch(&"ground")
		else:
			dispatch(&"air")
