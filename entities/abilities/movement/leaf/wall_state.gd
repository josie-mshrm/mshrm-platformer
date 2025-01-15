class_name WallState
extends MoveState

func _enter() -> void:
	wall_check_buffer()

func _exit() -> void:
	pass

func _update(delta: float) -> void:
	host.move_character_x(delta, x_mod)
	
	limit_wall_slide_speed()
	
	if not host.wall_branch.check_input_for_wall_direction():
		dispatch(&"air")


func limit_wall_slide_speed():
	if soul.velocity.y >= host.wall_slide_speed:
		soul.velocity.y -= 200 ## TODO change this to limit and slow


func wall_check_buffer():
	if host.buffer_active:
		if host.check_buffer(&"jump"):
			if soul.is_on_wall_only():
				host.wall_branch.get_wall_ray_direction()
				dispatch(&"wall kick")
			elif host.can_jump():
				host.is_jump = true
				dispatch(&"jump")
