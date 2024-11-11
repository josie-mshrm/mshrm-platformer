class_name MovementTree
extends MoveHSM

@onready var idle_state: IdleState = $IdleState
@onready var run_state: RunState = $RunState
@onready var fall_state: FallState = $FallState
@onready var jump_state: JumpState = $JumpState


func _ready() -> void:
	soul = $".."
	
	soul.player_input_action.connect(on_player_input)
	
	calc_jump_var()
	gravity.y = fall_gravity
	max_velocity = soul.speed
	accel = soul.speed / accel_time
	
	for child in get_children():
		if child is MoveState:
			child.soul = soul
			child.host = self
	

func _setup() -> void:
	initial_state = idle_state
	
	add_transition(run_state, idle_state, &"idle")
	add_transition(ANYSTATE, run_state, &"run")
	add_transition(ANYSTATE, jump_state, &"jump")
	add_transition(ANYSTATE, fall_state, &"fall")
	
	add_transition(jump_state, fall_state, &"end jump")

func _update(delta: float) -> void:
	## Apply gravity
	soul.velocity.y += gravity.y * delta
	
	if soul.is_on_floor_only() and soul.input_direction.x == 0:
		dispatch(&"idle")

## Function for changing state based on player inputs
func on_player_input(action: StringName):
	if action == "jump":
		dispatch(&"jump")
