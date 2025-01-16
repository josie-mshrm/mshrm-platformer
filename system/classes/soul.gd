class_name Soul
extends CharacterBody2D

signal platform_hit(platform: Platform)

@export var action_list: ActionList

@export var health_mod: HealthModule
@export var max_health: int
@export_range(0, 4) var speed: float


var input_direction : Vector2 = Vector2.ZERO

var control_node: Controller

@onready var soul_raycast_dict := {
	&"RayDown" : $RayDown,
	&"RayLeft" : $RayLeft,
	&"RayRight" : $RayRight,
}

func _ready() -> void:
	pass


## Send the action from the controller to the appropriate node
## Currently this is just the state machine, but this can be used elsewhere to trigger
## animations, sound effects, etc.
func on_recieve_action(_control_action : StringName, _event : InputEvent):
	pass

func on_recieve_movement(_direction: Vector2):
	pass

func get_valid_actions() -> Array:
	## Get the list of allowed actions from the action list arrays
	## The values themselves are arrays, must loop through them
	var valid_actions_list : Array
	
	for value in action_list.ActionDict.values(): # For each of the Dictionary's Arrays
		valid_actions_list.append_array(value)
	
	return valid_actions_list

## Connect to the controller's "send_action" signal
func init_control_node():
	control_node.ctrl_send_action.connect(on_recieve_action)
	control_node.ctrl_send_movement.connect(on_recieve_movement)
