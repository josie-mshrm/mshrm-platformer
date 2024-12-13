class_name MoveState
extends LimboState

@export var x_mod : float = 1
var soul : Soul
var host: MovementTree

func _setup() -> void:
	host = get_root()

func _enter() -> void:
	pass

func _exit() -> void:
	pass

func _update(_delta: float) -> void:
	pass
