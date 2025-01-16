class_name WallJumpState
extends JumpState

var wall_kick_rad : float = 0

## Vectors that defines the wall kick direction
var kick_vector_left : Vector2
var kick_vector_right : Vector2


func _setup() -> void:
	wall_kick_rad = deg_to_rad(host.wall_kick_angle)
	
	calc_wall_kick()


func _enter() -> void:
	host.gravity.y = host.jump_gravity
	
	wall_jump()


func wall_jump():
	if host.wall_branch.wall_direction.x == -1:
		soul.velocity = kick_vector_left
	elif host.wall_branch.wall_direction.x == 1:
		soul.velocity = kick_vector_right
	else:
		print("fail")
	await get_tree().create_timer(host.jump_peak_time, true, true, false).timeout
	dispatch(&"air")


func calc_wall_kick():
	var left_from_angle : float = (PI/2) + (wall_kick_rad * -1)
	var right_from_angle : float = (PI/2) + wall_kick_rad
	kick_vector_left = Vector2(host.wall_kick_force, host.jump_velocity) * Vector2.from_angle(left_from_angle)
	kick_vector_right = Vector2(host.wall_kick_force, host.jump_velocity) * Vector2.from_angle(right_from_angle)
