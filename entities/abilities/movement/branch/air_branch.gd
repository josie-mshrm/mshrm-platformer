class_name AirBranch
extends MoveBranch

func _setup() -> void:
	host = get_root()
	
	for child in get_children():
		child.soul = soul
		child.host = host

func _update(delta: float) -> void:
	if soul.is_on_floor():
		jump_counter = 0
		dispatch("landed")
	
	# If soul is on wall and sliding down
	if soul.is_on_wall_only() and soul.velocity.y > 0:
		dispatch("wall")

func start_coyote_timer():
	host.is_coyote = true
	await get_tree().create_timer(host.coyote_time).timeout
	host.is_coyote = false
