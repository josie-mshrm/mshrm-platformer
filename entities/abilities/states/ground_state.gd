class_name GroundState
extends LimboState

var soul : Soul
var accel
var reaccelerate : bool = true

@export var coyote_time : float = 0.2
@export var accel_time : float = 0.25
@export var decel_rate : float = 0.4

@onready var move_hsm: LimboHSM = $".."

func _setup() -> void:
	accel = soul.speed / accel_time

func _enter() -> void:
	pass

func _exit() -> void:
	pass

func _update(delta: float) -> void:
	if soul.input_direction.x != 0:
		print(soul.velocity.x)
		if abs(soul.velocity.x) < move_hsm.max_velocity:
			soul.velocity.x += accel * delta * soul.input_direction.x
		else:
			soul.velocity.x = soul.speed * soul.input_direction.x
	else:
		print("no input")
		soul.velocity.x -= decel_rate * accel * sign(soul.velocity.x) * delta
	
	
	if soul.is_on_floor() == false: #if the soul was on ground, and is now falling
		start_coyote_timer()
		dispatch("air")

func start_coyote_timer():
	move_hsm.is_coyote = true
	await get_tree().create_timer(coyote_time).timeout
	move_hsm.is_coyote = false

## TODO add directional snap
## TODO add ground acceleration
