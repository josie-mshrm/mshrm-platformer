extends LimboHSM

@export var coyote_time : float = 0.2
@export var accel_time : float = 0.25
@export var decel_rate : float = 0.4

@onready var soul: Player = $".."
@onready var ground_state: GroundState = $GroundState
@onready var air_state: AirState = $AirState
@onready var wall_state: WallState = $WallState

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
	wall_state.soul = soul
	initial_state = ground_state
	
	add_transition(ground_state, air_state, "jump")
	add_transition(air_state, ground_state, "landing")
	add_transition(air_state, wall_state, "wall hit")
	add_transition(wall_state, air_state, "wall jump")


func _update(delta: float) -> void:
	## Apply gravity
	soul.velocity.y += gravity.y * delta
	
	soul.move_and_slide()

## Function for changing state based on player inputs
func on_player_input(action: StringName):
	if action == "jump":
		if air_state.can_jump():
			var state : LimboState = get_active_state()
			match state:
				GroundState:
					air_state.jump_type = air_state.Jump.BASIC
					dispatch("jump")
				WallState:
					air_state.jump_type = air_state.Jump.WALL
					dispatch("wall jump")
				_:
					air_state.jump_type = air_state.Jump.BASIC
					dispatch("jump")
			
			
			

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

## TODO add wall slide
## TODO add wall jump
## TODO add input buffering
