class_name AirHSM
extends MoveHSM

var jumping : bool = false

func _setup() -> void:
	host = get_root()

func _update(delta: float) -> void:
	if soul.is_on_floor():
		jump_counter = 0
		dispatch("ground")
	
	# If soul is on wall and sliding down
	if soul.is_on_wall_only() and soul.velocity.y > 0:
		dispatch("wall")

func start_coyote_timer():
	host.is_coyote = true
	await get_tree().create_timer(host.coyote_time).timeout
	host.is_coyote = false
