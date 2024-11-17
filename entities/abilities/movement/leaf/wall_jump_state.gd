class_name WallJumpState
extends JumpState

var wall_kick_rad : float = 0
## Vector that defines the wall kick direction
var wall_kick : Vector2

func _setup() -> void:
	# Sets the "can_jump" function to be a check before entering this state
	#set_guard(host.can_jump)
	wall_kick_rad = deg_to_rad(host.wall_kick_angle)
	set_wall_kick_angle()

func _enter() -> void:
	host.gravity.y = host.jump_gravity
	
	if host.wall_branch.wall_direction == Vector2.LEFT:
		var from_angle : float = (PI/2) - wall_kick_rad
		wall_kick *= Vector2.from_angle(from_angle)
	if host.wall_branch.wall_direction == Vector2.RIGHT:
		var from_angle : float = (PI/2) + wall_kick_rad
		wall_kick *= Vector2.from_angle(from_angle)
	wall_jump()

func _update(delta: float) -> void:
	pass

func wall_jump():
	soul.velocity = wall_kick
	await get_tree().create_timer(host.jump_peak_time, true, true, false).timeout
	dispatch(&"air")
	set_wall_kick_angle()

func set_wall_kick_angle():
	wall_kick = Vector2(host.wall_kick_force, host.jump_velocity)
