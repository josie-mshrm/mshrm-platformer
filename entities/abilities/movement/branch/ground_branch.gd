class_name GroundBranch
extends MoveHSM

@onready var idle_state: IdleState = $IdleState
@onready var run_state: RunState = $RunState

func _setup() -> void:
	host = get_root()
	for child in get_children():
		child.soul = soul
		child.host = host
	
	add_transition(ANYSTATE, run_state, &"run")
	add_transition(ANYSTATE, idle_state, &"idle")
	
	initial_state = idle_state

func _enter() -> void:
	if soul.input_direction.x != 0:
		dispatch(&"run")
	else:
		dispatch(&"idle")

func _update(delta: float) -> void:
	host.move_character_x(delta, x_mod)
	
	#if the soul was on ground, and is now falling
	if not soul.is_on_floor() and soul.velocity.y > 0:
		dispatch(&"fall")
