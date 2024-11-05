class_name MovementTree
extends MoveBranch

@onready var ground_branch: GroundBranch = $GroundBranch
@onready var air_branch: AirBranch = $AirBranch


func _ready() -> void:
	soul = $".."
	
	soul.player_input_action.connect(on_player_input)
	
	gravity.y = fall_gravity
	max_velocity = soul.speed
	
	accel = soul.speed / accel_time
	
	calc_jump_var()
	
	for child in get_children():
		child.soul = soul
		child.host = self

func _setup() -> void:
	add_transition(ground_branch, air_branch, "jumped")
	add_transition(ground_branch, air_branch, "fell")
	add_transition(ANYSTATE, ground_branch, "landed")

func _update(delta: float) -> void:
	## Apply gravity
	soul.velocity.y += gravity.y * delta

## Function for changing state based on player inputs
func on_player_input(action: StringName):
	
	if action == "jump":
		dispatch("jumped")
	
	var state = get_leaf_state()
	print(state)
