class_name WallJumpState
extends JumpState

func _setup() -> void:
	# Sets the "can_jump" function to be a check before entering this state
	set_guard(host.can_jump) 

func _enter() -> void:
	host.gravity.y = host.jump_gravity
	wall_jump()

func wall_jump():
	soul.velocity.y = host.jump_velocity
	soul.velocity.x = -(sign(soul.input_direction.x)) * 500 ##HACK for wall jump
	host.jump_counter += 1
	await get_tree().create_timer(host.jump_peak_time, true, true, false).timeout
	dispatch(&"air")
