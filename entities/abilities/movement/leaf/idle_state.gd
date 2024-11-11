class_name IdleState
extends MoveState

func _setup() -> void:
	host = get_root()

func _enter() -> void:
	pass

func _exit() -> void:
	pass

func _update(delta: float) -> void:
	soul.move_and_slide()
	
	if soul.input_direction.x != 0:
		dispatch(&"run")
	
