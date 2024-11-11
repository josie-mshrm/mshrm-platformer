class_name MovementTree
extends MoveBranch

@onready var ground_branch: GroundBranch = $GroundBranch
@onready var air_branch: AirBranch = $AirBranch

@onready var label: Label = $"../Label"

func _ready() -> void:
	soul = $".."
	
	soul.player_input_action.connect(on_player_input)
	
	calc_jump_var()
	gravity.y = fall_gravity
	max_velocity = soul.speed
	accel = soul.speed / accel_time
	
	for child in get_children():
		if child is MoveBranch:
			child.soul = soul
			child.host = self
			child.active_state_changed.connect(child_state_changed)
		

func _setup() -> void:
	add_transition(ANYSTATE, ground_branch, &"ground")
	add_transition(ANYSTATE, air_branch, &"air")

func _update(delta: float) -> void:
	## Apply gravity
	soul.velocity.y += gravity.y * delta

## Function for changing state based on player inputs
func on_player_input(action: StringName):
	if action == "jump":
		air_enter_jump()


func child_state_changed(state, last_state):
	print(state.name)
	label.text = state.name


func ground_enter_idle():
	ground_branch.initial_state = ground_branch.idle_state
	dispatch(&"ground")

func ground_enter_run():
	ground_branch.initial_state = ground_branch.run_state
	dispatch(&"ground")

func air_enter_jump():
	if air_branch.initial_state != air_branch.jump_state:
		air_branch.initial_state = air_branch.jump_state
	dispatch(&"air")
