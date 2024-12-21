class_name JumpState
extends MoveState

func _setup() -> void:
	# Sets the "can_jump" function to be a check before entering this state
	set_guard(host.can_jump)

func _enter() -> void:
	host.gravity.y = host.jump_gravity
	jump()

func _exit() -> void:
	host.gravity = host.project_gravity * host.gravity_mod

func _update(delta: float) -> void:
	host.move_character_x(delta, x_mod)


func jump():
	soul.velocity.y = host.jump_velocity
	host.jump_counter += 1
	await get_tree().create_timer(host.jump_peak_time, true, true, false).timeout
	dispatch(&"end jump")
