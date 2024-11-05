class_name GroundHSM
extends MoveHSM

@export var state_x_modifier : int

func _setup() -> void:
	pass

func _update(delta: float) -> void:
	host.move_character_x(delta, state_x_modifier)
	
	if not soul.is_on_floor() and soul.velocity.y > 0: #if the soul was on ground, and is now falling
		dispatch("air")

## TODO add directional snap
