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


func _update(delta: float) -> void:
	
	get_wall_direction()
	
	if soul.is_on_floor():
		dispatch(&"ground")

func get_wall_direction():
	last_wall_direction = wall_direction
	if soul.is_on_wall():
		wall_direction.x = sign(soul.get_wall_normal().x) * -1
	else:
		wall_direction.x = 0
	

func check_wall_direction(cargo = null) -> bool:
	if not soul.is_on_wall():
		return false
	if sign(soul.input_direction.x) != sign(wall_direction.x):
		return false
	return true
