class_name FallState
extends MoveState

func _setup() -> void:
	host = get_root()

func _enter() -> void:
	pass

func _exit() -> void:
	pass

func _update(delta: float) -> void:
	host.move_character_x(delta, x_mod)
	
	soul.move_and_slide()
