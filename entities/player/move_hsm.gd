extends LimboHSM

@export var coyote_time : float = 0.2
@export var accel_time : float = 0.25
@export var decel_rate : float = 0.4

@onready var soul: Player = $".."
@onready var ground_state: GroundState = $GroundState
@onready var air_state: AirState = $AirState

var jump_pressed : bool = false
var gravity : Vector2
var max_velocity : int
var accel : float

## Dependency Variables
var is_coyote : bool = false

func _ready() -> void:
	soul.player_input_action.connect(on_player_input)
	gravity.y = 980
	max_velocity = soul.speed

func _setup() -> void:
	accel = soul.speed / accel_time
	
	ground_state.soul = soul
	air_state.soul = soul
	initial_state = ground_state
	
	add_transition(ANYSTATE, air_state, "jump")
	add_transition(ANYSTATE, air_state, "air")
	add_transition(air_state, ground_state, "ground")
	


func _update(delta: float) -> void:
	## Apply gravity
	soul.velocity.y += gravity.y * delta
	
	soul.move_and_slide()

## Function for changing state based on player inputs
func on_player_input(action: StringName):
	if action == "jump":
		if air_state.can_jump():
			air_state.is_jump = true
			change_active_state(air_state)

## Function for moving the character on the x axis based on player input, including a modifier for the speed of movement
func move_character_x(delta: float, state_mod: float):
	# if there is an input being pressed
	if soul.input_direction.x != 0: 
		if absf(soul.velocity.x) < max_velocity:
			soul.velocity.x += accel * delta * soul.input_direction.x * state_mod
		else:
			soul.velocity.x = soul.speed * soul.input_direction.x * state_mod
	
	# if there is no input
	else: 
		if absf(soul.velocity.x) <= 30:
			soul.velocity.x = 0
		else:
			soul.velocity.x -= decel_rate * accel * sign(soul.velocity.x) * delta * state_mod

## TODO add wall state
## TODO add wall slide
## TODO add input buffering
