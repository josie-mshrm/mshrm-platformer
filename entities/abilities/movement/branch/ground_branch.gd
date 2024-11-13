class_name GroundBranch
extends MoveBranch

@onready var idle_state: IdleState = $IdleState
@onready var run_state: RunState = $RunState

func _ready() -> void:
	set_guard(floor_check)

func _setup() -> void:
	
	for child in get_children():
		child.soul = soul
		child.host = host
	
	add_transition(ANYSTATE, run_state, &"run")
	add_transition(ANYSTATE, idle_state, &"idle")

func _enter() -> void:
	host.jump_counter = 0
	
	if soul.velocity.x != 0:
		initial_state = run_state
	else:
		initial_state = idle_state
	
	call_deferred("check_on_enter")


func _update(_delta: float) -> void:
	
	#if the soul was on ground, and is now falling
	if not soul.is_on_floor() and soul.velocity.y > 0:
		dispatch(&"fall")

func check_on_enter():
	if host.buffer_active:
		if host.check_buffer(&"jump"):
			host.is_jump = true
			dispatch(&"air")


func floor_check() -> bool:
	if soul.is_on_floor():
		return true
	else:
		return false
