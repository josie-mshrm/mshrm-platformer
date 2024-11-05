extends MoveHSM

@onready var groundHSM: GroundHSM = $GroundHSM
@onready var airHSM: AirHSM = $AirHSM
@onready var wallHSM: WallHSM
@onready var jump_state: JumpState = $AirHSM/JumpState

func _ready() -> void:
	soul = get_parent()
	soul.player_input_action.connect(on_player_input)
	
	gravity.y = fall_gravity
	max_velocity = soul.speed
	
	accel = soul.speed / accel_time
	
	calc_jump_var()
	
	for child in get_children():
		child.soul = soul

func _setup() -> void:
	
	#add_transition(groundHSM, jump_state, "floor jump")
	add_transition(airHSM, groundHSM, "floor hit")
	add_transition(wallHSM, airHSM, "wall jump")
	#add_transition(airHSM, wallHSM, "wall hit")
	#add_transition(jump_state, airHSM, "end jump")
	



func _update(delta: float) -> void:
	super(delta)
	soul.move_and_slide()

## Function for changing state based on player inputs
func on_player_input(action: StringName):
	if action == "jump":
		if airHSM.can_jump():
			var state : LimboState = get_active_state()
			match state:
				GroundHSM:
					dispatch("jump")
				WallHSM:
					dispatch("wall jump")
				_:
					dispatch("jump")





## TODO add wall slide
## TODO add wall jump
## TODO add input buffering
