class_name FallState
extends MoveState

func _setup() -> void:
	pass


func _enter() -> void:
	call_deferred("fall_check_buffer")


func _exit() -> void:
	pass


func _update(delta: float) -> void:
	host.move_character_x(delta, x_mod)
	
	if soul.is_on_floor_only():
		dispatch(&"ground")
	
	if soul.is_on_wall_only() and soul.input_direction.x != 0:
		dispatch(&"wall")
	

func fall_check_buffer():
	if host.buffer_active and host.can_jump():
		if host.check_buffer(&"jump"):
			if soul.is_on_wall_only():
				host.is_jump = true
				dispatch(&"wall")
			else:
				dispatch(&"jump")
