class_name WallJumpState
extends MoveState

func _setup() -> void:
	pass

func _enter() -> void:
	pass

func _exit() -> void:
	pass

func _update(delta: float) -> void:
	host.move_character_x(delta, x_mod)
