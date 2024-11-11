class_name JumpState
extends MoveState

func _setup() -> void:
	# Sets the "can_jump" function to be a check before entering this state
	set_guard(can_jump) 

func _enter() -> void:
	host.gravity.y = host.jump_gravity
	jump()

func _exit() -> void:
	host.gravity.y = host.fall_gravity

func _update(delta: float) -> void:
	
	if surface_hit():
		dispatch("end jump")
	
	soul.move_and_slide()

func jump():
	soul.velocity.y = host.jump_velocity
	host.jump_counter += 1
	await get_tree().create_timer(host.jump_peak_time).timeout
	dispatch("end jump")

func surface_hit() -> bool:
	if soul.is_on_floor():
		return true
	if soul.is_on_wall:
		return true
	else:
		return false

## Checks whether the character is in a viable state to perform the jump
func can_jump() -> bool:
	if host.jump_counter >= host.jumps:
		return false
	else:
		return true
