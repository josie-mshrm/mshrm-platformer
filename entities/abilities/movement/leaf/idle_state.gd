class_name IdleState
extends MoveState

func _setup() -> void:
	host = get_root()


func _enter() -> void:
	pass


func _exit() -> void:
	pass


func _update(delta: float) -> void:
	host.move_character_x(delta, x_mod)
	
	if soul.input_direction.x != 0:
		dispatch(&"run")
	
