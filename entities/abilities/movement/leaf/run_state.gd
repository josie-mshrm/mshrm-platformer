class_name RunState
extends MoveState

func _enter() -> void:
	host.jump_counter = 0

func _exit() -> void:
	pass

func _update(delta: float) -> void:
	host.move_character_x(delta, x_mod)
	
	soul.move_and_slide()
	
	if soul.input_direction.x == 0:
		dispatch(&"idle")
	
	#if the soul was on ground, and is now falling
	if not soul.is_on_floor() and soul.velocity.y > 0:
		dispatch(&"fall")
