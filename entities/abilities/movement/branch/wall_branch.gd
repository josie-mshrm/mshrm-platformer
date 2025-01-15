class_name WallBranch
extends MoveBranch

var wall_direction : Vector2
var last_wall_direction : Vector2

@onready var wall_state: WallState = $WallState
@onready var wall_jump_state: WallJumpState = $"Wall JumpState"

func _setup() -> void:
	host = get_root()
	
	for child in get_children():
		child.soul = soul
		child.host = host
	
	add_transition(ANYSTATE, wall_state, &"wall")
	add_transition(ANYSTATE, wall_jump_state, &"wall kick")

func _enter() -> void:
	if host.is_jump == true:
		initial_state = wall_jump_state
		host.is_jump = false
	else:
		initial_state = wall_state

func _exit() -> void:
	wall_direction = Vector2.ZERO


func _update(_delta: float) -> void:
	
	get_wall_ray_direction()
	
	if soul.is_on_floor():
		dispatch(&"ground")


func check_input_for_wall_direction() -> bool:
	if not soul.is_on_wall():
		return false
	if sign(soul.input_direction.x) != sign(wall_direction.x):
		return false
	return true


func get_wall_ray_direction():
	if wall_direction.x != 0:
		last_wall_direction = wall_direction
	# The raycast can only detect in layer 2, which is always ground/walls/ceiling
	# Therefore if the raycast is colliding, that is enough of a check
	if host.ray_left.is_colliding():
		wall_direction.x = -1
	elif host.ray_right.is_colliding():
		wall_direction.x = 1
	else:
		wall_direction.x = 0
