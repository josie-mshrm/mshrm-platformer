class_name FallState
extends MoveState

func _setup() -> void:
	pass


func _enter() -> void:
	if host.buffer_active and host.can_jump():
		if host.check_buffer(&"jump"):
			dispatch(&"jump")


func _exit() -> void:
	pass


func _update(delta: float) -> void:
	host.move_character_x(delta, x_mod)
	
	if soul.is_on_floor_only():
		dispatch(&"ground")
	
	if soul.is_on_wall_only():
		dispatch(&"wall")
