class_name GroundBranch
extends MoveBranch

@export var state_x_modifier : int

@onready var idle_state: IdleState = $IdleState
@onready var run_state: RunState = $RunState

func _setup() -> void:
	host = get_root()
	for child in get_children():
		child.soul = soul
		child.host = host
	
	add_transition(idle_state, run_state, "moving")
	add_transition(run_state, idle_state, "stopped")
	
	initial_state = idle_state

func _enter() -> void:
	if soul.input_direction.x != 0:
		change_active_state(run_state)
	else:
		change_active_state(idle_state)

func _update(delta: float) -> void:
	host.move_character_x(delta, state_x_modifier)
	
	#if the soul was on ground, and is now falling
	if not soul.is_on_floor() and soul.velocity.y > 0:
		dispatch("jumped")
