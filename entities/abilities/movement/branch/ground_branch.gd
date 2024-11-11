class_name GroundBranch
extends MoveBranch

@onready var idle_state: IdleState = $IdleState
@onready var run_state: RunState = $RunState

func _ready() -> void:
	set_guard(floor_check)

func _setup() -> void:
	add_transition(ANYSTATE, run_state, &"run")
	add_transition(ANYSTATE, idle_state, &"idle")
	
	for child in get_children():
		if child is MoveState or MoveBranch:
			child.soul = soul

func _enter() -> void:
	host.jump_counter = 0
	
	if soul.velocity.x != 0:
		initial_state = run_state
	else:
		initial_state = idle_state

func _update(delta: float) -> void:
	host.move_character_x(delta, x_mod)
	
	#if the soul was on ground, and is now falling
	if not soul.is_on_floor() and soul.velocity.y > 0:
		dispatch(&"fall")

func floor_check() -> bool:
	if soul.is_on_floor():
		return true
	else:
		return false
