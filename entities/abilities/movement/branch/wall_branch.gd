class_name WallBranch
extends MoveBranch


@onready var wall_state: WallState = $WallState


func _setup() -> void:
	host = get_root()
	
	for child in get_children():
		child.soul = soul
		child.host = host
	
	add_transition(ANYSTATE, wall_state, &"wall")

func _update(delta: float) -> void:
	
	if soul.is_on_floor_only():
		dispatch(&"ground")
