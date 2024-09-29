class_name Soul
extends CharacterBody2D


@export var control_node: Controller
@export var health_mod: HealthModule
@export var max_health: int
@export var speed: int

var InputType = control_node.InputType

## List of possible actions taken by this soul: ("action name" : InputType)
var actions : Dictionary = {"name" : InputType}

func _enter_tree() -> void:
	control_node.send_action.connect(on_recieve_action)

func on_recieve_action(action):
	print(action + " recieved")
