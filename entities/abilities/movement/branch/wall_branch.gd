class_name WallBranch
extends MoveBranch

func _setup() -> void:
	host = get_root()

func _update(delta: float) -> void:
	if soul.is_on_floor():
		dispatch("ground")

func start_coyote_timer():
	host.is_coyote = true
	await get_tree().create_timer(host.coyote_time).timeout
	host.is_coyote = false
