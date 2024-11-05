class_name WallHSM
extends LimboHSM

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
	
	if soul.is_on_floor():
		dispatch("ground")
	
	if not soul.is_on_wall_only():
		dispatch("air")
