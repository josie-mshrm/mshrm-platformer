class_name RunState
extends MoveState

func _setup() -> void:
	host = get_root()


func _enter() -> void:
	pass


func _exit() -> void:
	pass


func _update(delta: float) -> void:
	host.move_character_x(delta, x_mod)
	
	if soul.input_direction.x == 0:
		dispatch(&"idle")
	
	#if the soul was on ground, and is now falling
	if not soul.is_on_floor() and soul.velocity.y > 0:
		host.air_branch.start_coyote_timer()
		dispatch(&"fall")
