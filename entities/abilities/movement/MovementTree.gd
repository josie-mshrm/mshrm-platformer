class_name MovementTree
extends MoveBranch

@export_group("Movement Stats")
@export var accel_time : float = 0.25
@export var decel_rate : float = 0.97
@export var jumps: int = 3
@export var jump_height: float = 25.0
@export var jump_peak_time: float = 0.4
@export var jump_fall_time: float = 0.3
@export var min_jump_time: float = 0.15
@export var coyote_time: float = 0.25
@export var buffer_time: float = 0.15

var gravity : Vector2
var max_velocity : int
var accel : float
var jump_counter: int = 0
var jump_velocity: float
var jump_gravity: float
var fall_gravity: float

var is_jump : bool = false
var is_coyote : bool = false
var state : MoveState = null
var last_state : MoveState = null

var input_buffer : Dictionary = {
	&"jump" : null,
	&"wall jump" : null,
	}
var buffer_active : bool = false


@onready var ground_branch: GroundBranch = $GroundBranch
@onready var air_branch: AirBranch = $AirBranch
@onready var wall_branch: WallBranch = $WallBranch


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


func _setup() -> void:
	
	add_transition(ANYSTATE, air_branch, &"air")
	add_transition(air_branch, ground_branch, &"ground")
	add_transition(ground_branch, air_branch, &"fall")
	add_transition(air_branch, wall_branch, &"wall")


func _update(delta: float) -> void:
	## Apply gravity
	soul.velocity.y += gravity.y * delta
	
	soul.move_and_slide()


## Function for changing state based on player inputs
func on_player_input(action: StringName, event : InputEvent):
	if action == &"jump":
		var state = get_tree_state()
		
		if state == air_branch.jump_state:
			buffer_input(action, event)
		if state == air_branch.fall_state:
			dispatch(&"jump")
		else:
			is_jump = true
			dispatch(&"air")


## Function for moving the character on the x axis based on player input, including a modifier for the speed of movement
func move_character_x(delta: float, state_mod: float):
	# if there is an input being pressed
	if soul.input_direction.x != 0: 
		if absf(soul.velocity.x) < max_velocity:
			soul.velocity.x += accel * delta * sign(soul.input_direction.x) * state_mod
		else:
			soul.velocity.x = soul.speed * sign(soul.input_direction.x) * state_mod
	
	# if there is no input
	else: 
		if absf(soul.velocity.x) <= 30:
			soul.velocity.x = 0
		else:
			soul.velocity.x -= decel_rate * accel * sign(soul.velocity.x) * delta * state_mod

func calc_jump_var():
	jump_velocity = ((2.0 * jump_height) / jump_peak_time) * -10.0
	jump_gravity = ((-2.0 * jump_height) / (jump_peak_time * jump_peak_time)) * -10.0
	fall_gravity = ((-2.0 * jump_height) / (jump_fall_time * jump_fall_time)) * -10.0

func get_tree_state() -> MoveState:
	last_state = state
	state = get_leaf_state()
	return state

func buffer_input(action: StringName, event: InputEvent):
	#if something is already in the buffer, clear it first
	if buffer_active:
		input_buffer[action] = false
	
	buffer_active = true
	input_buffer[action] = event
	await get_tree().create_timer(buffer_time, true, true, false).timeout
	input_buffer[action] = false
	buffer_active = false
