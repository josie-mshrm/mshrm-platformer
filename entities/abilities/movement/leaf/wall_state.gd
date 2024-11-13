class_name WallState
extends MoveState

func _update(delta: float) -> void:
	host.move_character_x(delta, x_mod)
	
	if soul.is_on_floor():
		dispatch(&"ground")
	if not soul.is_on_wall_only() and not soul.is_on_floor():
		dispatch(&"air")
