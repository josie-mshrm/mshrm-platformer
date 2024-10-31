class_name AirState
extends LimboState

var soul: Soul
var jumping : bool = false

@export var jump_height: float = 25.0
@export var jump_peak_time: float = 0.4
@export var jump_fall_time: float = 0.3
@export var min_jump_time: float = 0.15
@export var jumps: int = 3
@export var x_mod: float = 1

@onready var move_hsm: LimboHSM = $".."

## Enum for passing through jump type from previous state
enum Jump {NONE, BASIC, WALL}
var jump_type = Jump.NONE

var jump_counter: int = 0
var jump_velocity: float
var jump_gravity: float
var fall_gravity: float
var release_time: float = 0

func _setup() -> void:
	jump_velocity = ((2.0 * jump_height) / jump_peak_time) * -10.0
	jump_gravity = ((-2.0 * jump_height) / (jump_peak_time * jump_peak_time)) * -10.0
	fall_gravity = ((-2.0 * jump_height) / (jump_fall_time * jump_fall_time)) * -10.0


func _enter() -> void:
	#if jump_type == Jump.BASIC:
		#jump()
		#jump_type = Jump.NONE
	#match jump_type:
		#Jump.NONE: pass
		#Jump.BASIC: jump()
		#Jump.WALL: wall_jump()
	#jump_type = Jump.NONE
	pass

func _exit() -> void:
	move_hsm.gravity.y = 980


func _update(delta: float) -> void:
	move_hsm.move_character_x(delta, x_mod)
	
	match jump_type:
		Jump.NONE: pass
		Jump.BASIC: jump()
		Jump.WALL: wall_jump()
	jump_type = Jump.NONE
	
	if jumping:
		move_hsm.gravity.y = jump_gravity
	else:
		move_hsm.gravity.y = fall_gravity
	
	if soul.is_on_floor():
		jump_counter = 0
		dispatch("ground")
	
	if soul.is_on_wall_only() and soul.velocity.y > 0:
		dispatch("wall")

## Checks whether the character is in a viable state to perform the jump
func can_jump() -> bool:
	if jump_counter >= jumps:
		return false
	
	var state : LimboState = move_hsm.get_active_state()
	if state is GroundState \
	or state is AirState and move_hsm.is_coyote == true \
	or state is AirState and jumps > 1 \
	or state is WallState and jumps > 1:
		return true
	else:
		return false

func jump():
	jumping = true
	jump_counter += 1
	soul.velocity.y = jump_velocity
	await get_tree().create_timer(jump_peak_time).timeout
	jumping = false

func wall_jump():
	jumping = true
	jump_counter += 1
	soul.velocity.y = jump_velocity
	await get_tree().create_timer(jump_peak_time).timeout
	jumping = false
