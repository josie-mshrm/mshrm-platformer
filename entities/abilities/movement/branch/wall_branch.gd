class_name WallBranch
extends MoveBranch


@onready var wall_state: WallState = $WallState
@onready var wall_jump_state: WallJumpState = $"Wall JumpState"


func _setup() -> void:
	host = get_root()
	
	for child in get_children():
		child.soul = soul
		child.host = host
	
	add_transition(ANYSTATE, wall_state, &"wall")
	add_transition(ANYSTATE, wall_jump_state, &"wall jump")

func _enter() -> void:
	if host.is_jump == true:
		initial_state = wall_jump_state
		host.is_jump = false
	else:
		initial_state = wall_state


func _update(delta: float) -> void:
	
	if soul.is_on_floor():
		dispatch(&"ground")
