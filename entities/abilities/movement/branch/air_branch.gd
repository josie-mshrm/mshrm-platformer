class_name AirBranch
extends MoveBranch

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
	if host.is_jump == true:
		initial_state = jump_state
		host.is_jump = false
	else:
		initial_state = fall_state


func _exit() -> void:
	pass

func _update(_delta: float) -> void:
	pass


func start_coyote_timer():
	host.is_coyote = true
	await get_tree().create_timer(host.coyote_time, true, true, false).timeout
	host.is_coyote = false
