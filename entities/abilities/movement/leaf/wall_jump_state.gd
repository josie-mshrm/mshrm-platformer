class_name WallJumpState
extends JumpState

var wall_kick_rad : float = 0
## Vector that defines the wall kick direction
var wall_kick : Vector2


func _setup() -> void:
	wall_kick_rad = deg_to_rad(host.wall_kick_angle)


func _enter() -> void:
	host.gravity.y = host.jump_gravity
	
	wall_jump()


func wall_jump():
	calc_wall_kick_vector()
	soul.velocity = wall_kick
	await get_tree().create_timer(host.jump_peak_time, true, true, false).timeout
	dispatch(&"air")


func calc_wall_kick_vector():
	reset_wall_kick_angle()
	
	if host.wall_branch.wall_direction.x != 0:
		var from_angle : float = (PI/2) + (wall_kick_rad * host.wall_branch.wall_direction.x)
		wall_kick *= Vector2.from_angle(from_angle)
		print("wall direction")
	# if the wall direction is not left or right, use the last wall direction
	# TODO remove the need for last wall direction
	else:
		var from_angle : float = (PI/2) + (wall_kick_rad * host.wall_branch.last_wall_direction.x)
		wall_kick *= Vector2.from_angle(from_angle)
		print("buffer")

func reset_wall_kick_angle():
	wall_kick = Vector2(host.wall_kick_force, host.jump_velocity)
