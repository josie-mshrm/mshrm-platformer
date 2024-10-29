extends LimboHSM

@onready var soul: Player = $".."
@onready var ground_state: GroundState = $GroundState
@onready var air_state: AirState = $AirState

var jump_pressed : bool = false
var gravity : Vector2
var max_velocity : int

## Dependency Variables
var is_coyote : bool = false
var ground_mod : int = 1

func _ready() -> void:
	soul.player_input_action.connect(on_player_input)
	gravity.y = 980
	max_velocity = soul.speed

func _setup() -> void:
	ground_state.soul = soul
	air_state.soul = soul
	initial_state = ground_state
	
	add_transition(ANYSTATE, air_state, "jump")
	add_transition(ANYSTATE, air_state, "air")
	add_transition(air_state, ground_state, "ground")


func _update(delta: float) -> void:
	## Apply directional movement
	#soul.velocity.x = soul.speed * soul.input_direction.x * ground_mod
	## Apply gravity
	soul.velocity.y += gravity.y * delta
	
	soul.move_and_slide()

## Function for changing state based on player inputs
func on_player_input(action: StringName):
	if action == "jump":
		if air_state.can_jump():
			air_state.is_jump = true
			change_active_state(air_state)


## TODO add wall state
## TODO add wall slide
## TODO add input buffering
