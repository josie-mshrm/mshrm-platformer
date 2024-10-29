class_name GroundState
extends LimboState

@export var x_mod: float = 1

var soul : Soul

@onready var move_hsm: LimboHSM = $".."

func _setup() -> void:
	pass

func _enter() -> void:
	pass

func _exit() -> void:
	pass

func _update(delta: float) -> void:
	move_hsm.move_character_x(delta, x_mod)
	
	if soul.is_on_floor() == false: #if the soul was on ground, and is now falling
		start_coyote_timer()
		dispatch("air")

func start_coyote_timer():
	move_hsm.is_coyote = true
	await get_tree().create_timer(move_hsm.coyote_time).timeout
	move_hsm.is_coyote = false

## TODO add directional snap
## TODO add ground acceleration
