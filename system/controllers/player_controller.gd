extends Controller
class_name PlayerController


var player_node : Player
var input_controller: InputController
#const InputType = InputController.InputType

var ctrl_event : InputEvent
var ctrl_action : StringName
var action_dict : Dictionary
var input_event_list : Array[InputEvent]

func _ready():
	input_controller = $"/root/Input_Controller"
	player_node = $".."
	input_controller.input_detected.connect(_on_input_detected)
	action_dict = player_node.action_list.ActionDict


func _physics_process(_delta: float) -> void:
	ctrl_get_direction()
	ctrl_send_movement.emit(ctrl_move_dir)

## This function should pass in directions to the character
## It will filter input types
## The player should only receive single commands
func _on_input_detected(event: InputEvent, action: String, input_type: InputType):
	if action.begins_with("ui_"): # Filter out the UI inputs
		return
	if action.begins_with("move_"): # If it is a direction movement event
		return
	ctrl_event = event
	ctrl_action = action
	
	if input_type == InputType.ACTIVE:
		ctrl_send_action.emit(ctrl_action, ctrl_event)


func ctrl_get_direction():
	ctrl_move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
