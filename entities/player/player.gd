class_name Player
extends Soul

## Signal for actions that respond to the player's input



var valid_actions : Dictionary

@onready var movement_tree: MovementTree = $MovementTree
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var label: Label = $Label


func _ready() -> void:
	action_list.set_action_dict()
	
	## State Machine Setup
	movement_tree.initialize(self)
	movement_tree.set_active(true)
	
	control_node = $PlayerController
	
	init_control_node()


func _process(_delta: float) -> void:
	temp_flip_animation()
	
	label.text = movement_tree.get_tree_state().name


## Receives action from controller
## Sends action to state machine and emits signal for other nodes
func on_recieve_action(control_action : StringName, event : InputEvent):
	if valid_actions.is_empty():
		valid_actions = self.action_list.ActionDict
	
	if valid_actions.has(control_action): # If the action is allowed by the character body
		GlobalBus.player_input_action.emit(control_action, event)
	else:
		printerr("invalid input")
		printerr(control_action)


func on_recieve_movement(direction: Vector2):
	input_direction = direction

func temp_flip_animation():
	if velocity.x == 0:
		pass
	elif velocity.x > 0:
		animated_sprite_2d.flip_h = false
	elif velocity.x < 0:
		animated_sprite_2d.flip_h = true
