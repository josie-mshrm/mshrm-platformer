class_name MoveState
extends LimboState

@export var x_mod: float = 1

var soul : Soul

var host: MoveHSM

func _setup() -> void:
	host = get_root()

func _enter() -> void:
	pass

func _exit() -> void:
	pass

func _update(delta: float) -> void:
	host.move_character_x(delta, x_mod)
