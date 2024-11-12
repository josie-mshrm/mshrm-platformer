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

func _update(delta: float) -> void:
	pass

func check_buffer(action : StringName) -> bool:
	var event = host.input_buffer[action]
	
	if event is InputEvent:
		if event.is_action(action) and Input.is_action_pressed(action):
			host.input_buffer.clear()
			return true
	return false
