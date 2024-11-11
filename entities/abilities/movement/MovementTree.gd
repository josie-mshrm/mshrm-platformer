class_name MovementTree
extends MoveBranch

@onready var ground_branch: GroundBranch = $GroundBranch
@onready var air_branch: AirBranch = $AirBranch


func _ready() -> void:
	soul = $".."
	
	soul.player_input_action.connect(on_player_input)
	
	calc_jump_var()
	gravity.y = fall_gravity
	max_velocity = soul.speed
	accel = soul.speed / accel_time

	
	for child in get_children():
		child.soul = soul
		child.host = self

func _setup() -> void:
	add_transition(ground_branch, air_branch, &"jump")
	add_transition(ground_branch, air_branch, &"fall")
	add_transition(ANYSTATE, ground_branch, &"ground")

func _update(delta: float) -> void:
	## Apply gravity
	soul.velocity.y += gravity.y * delta

## Function for changing state based on player inputs
func on_player_input(action: StringName):
	
	if action == "jump":
		dispatch(&"jump")


func ground_enter_idle():
	ground_branch.initial_state = ground_branch.idle_state
	dispatch(&"ground")
