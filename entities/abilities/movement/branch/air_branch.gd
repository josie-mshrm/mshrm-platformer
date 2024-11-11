class_name AirBranch
extends MoveBranch


@onready var fall_state: FallState = $FallState
@onready var jump_state: JumpState = $JumpState

func _setup() -> void:
	host = get_root()
	
	for child in get_children():
		child.soul = soul
		child.host = host
	
	add_transition(jump_state, fall_state, &"end jump")
	add_transition(ANYSTATE, jump_state, &"jump")
	add_transition(ANYSTATE, fall_state, &"fall")


func _update(delta: float) -> void:
	host.move_character_x(delta, x_mod)
	
	if soul.is_on_floor():
		host.jump_counter = 0
		if soul.input_direction.x != 0:
			host.ground_enter_run()
		else:
			host.ground_enter_idle()
	
	# If soul is on wall and sliding down
	if soul.is_on_wall_only() and soul.velocity.y > 0:
		dispatch(&"wall")

func start_coyote_timer():
	host.is_coyote = true
	await get_tree().create_timer(host.coyote_time).timeout
	host.is_coyote = false
