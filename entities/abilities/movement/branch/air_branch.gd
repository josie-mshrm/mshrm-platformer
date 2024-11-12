class_name AirBranch
extends MoveBranch

var jump_flag : bool = false

@onready var fall_state: FallState = $FallState
@onready var jump_state: JumpState = $JumpState

func _setup() -> void:
	host = get_root()
	
	for child in get_children():
		child.soul = soul
		child.host = host
	
	add_transition(jump_state, fall_state, &"end jump")
	add_transition(ANYSTATE, jump_state, &"jump")
	add_transition(ANYSTATE, fall_state, &"fall")


func _enter() -> void:
	if jump_flag == true:
		initial_state = jump_state
	else:
		initial_state = fall_state


func _update(delta: float) -> void:
	host.move_character_x(delta, x_mod)
	
	if soul.is_on_floor_only():
		dispatch(&"ground")


func start_coyote_timer():
	host.is_coyote = true
	await get_tree().create_timer(host.coyote_time).timeout
	host.is_coyote = false
