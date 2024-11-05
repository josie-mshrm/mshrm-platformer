class_name MoveHSM
extends LimboHSM

@export_group("Movement Stats")
@export var accel_time : float = 0.25
@export var decel_rate : float = 0.9
@export var jumps: int = 3
@export var jump_height: float = 25.0
@export var jump_peak_time: float = 0.4
@export var jump_fall_time: float = 0.3
@export var min_jump_time: float = 0.15

var gravity : Vector2
var max_velocity : int
var accel : float
var jump_counter: int = 0
var jump_velocity: float
var jump_gravity: float
var fall_gravity: float

## Dependency Variables
var is_coyote : bool = false

var soul : Soul
var host : MoveHSM

func _ready() -> void:
	pass

## add transitions here. transitions must be from immediate children of this hsm
func _setup() -> void:
	pass

func _enter() -> void:
	pass

func _exit() -> void:
	pass

func _update(delta: float) -> void:
	## Apply gravity
	soul.velocity.y += gravity.y * delta


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

## Function for changing state based on player inputs
func on_player_input(action: StringName):
	pass

func calc_jump_var():
	jump_velocity = ((2.0 * jump_height) / jump_peak_time) * -10.0
	jump_gravity = ((-2.0 * jump_height) / (jump_peak_time * jump_peak_time)) * -10.0
	fall_gravity = ((-2.0 * jump_height) / (jump_fall_time * jump_fall_time)) * -10.0
