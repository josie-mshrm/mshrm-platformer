class_name FallState
extends MoveState

func _setup() -> void:
	pass

func _enter() -> void:
	pass

func _exit() -> void:
	pass

func _update(delta: float) -> void:
	soul.move_and_slide()
