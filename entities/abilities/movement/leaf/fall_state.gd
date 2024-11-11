class_name FallState
extends MoveState

func _setup() -> void:
	pass

func _enter() -> void:
	pass

func _exit() -> void:
	pass

func _update(delta: float) -> void:
	host.move_character_x(delta, x_mod)
	
	if soul.is_on_floor():
		dispatch(&"run")
	
	soul.move_and_slide()
