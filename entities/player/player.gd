class_name Player
extends Soul

## Signal for actions that respond to the player's input
signal player_input_action(action: StringName)

var input_direction : Vector2 = Vector2.ZERO
var valid_actions : Dictionary

@onready var movement_tree: MoveHSM = $MovementTree
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	action_list.set_action_dict()
	
	## State Machine Setup
	movement_tree.active_state_changed.connect(on_state_update)
	movement_tree.initialize(self)
	movement_tree.set_active(true)


func _process(delta: float) -> void:
	if input_direction.x < 0:
		animated_sprite_2d.flip_h = true
	elif input_direction.x > 0:
		animated_sprite_2d.flip_h = false

func on_state_update(state: LimboState, last_state : LimboState):
	pass
	#print(state)

## Receives action from controller
## Sends action to state machine and emits signal for other nodes
func on_recieve_action(control_action : StringName, _event : InputEvent):
	if valid_actions.is_empty():
		valid_actions = self.action_list.ActionDict
	
	if valid_actions.has(control_action): # If the action is allowed by the character body
		player_input_action.emit(control_action)
	else:
		print("invalid input")
		print(control_action)



func on_recieve_movement(direction: Vector2):
	input_direction = direction
