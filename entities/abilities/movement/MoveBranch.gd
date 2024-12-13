class_name MoveBranch
extends LimboHSM

@export var x_mod : float = 1

## Dependency Variables
var host : MovementTree
var soul: Soul


func _ready() -> void:
	pass

## add transitions here. transitions must be from immediate children of this hsm
func _setup() -> void:
	pass

func _enter() -> void:
	pass

func _exit() -> void:
	pass

## Function for changing state based on player inputs
func on_player_input(action: StringName, event: InputEvent):
	pass


func get_branch_state() -> MoveState:
	var state = get_active_state()
	return state
