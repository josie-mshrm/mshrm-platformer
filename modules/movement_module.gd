extends Node

signal directional_movement(direction)

const SPEED = 200
const JUMP_VELOCITY = -400.0
var move_velocity

func _physics_process(delta: float) -> void:
	var angle
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	if input_dir.length() != 0:
		angle = input_dir.angle() / (PI/4)
		angle = wrapi(int(angle), 0, 8)
	move_velocity = input_dir * SPEED
	directional_movement.emit(move_velocity)
