extends Controller
class_name PlayerController

const InputType = InputController.InputType
@export var input_controller: InputController

signal move_left
signal move_right
signal move_up
signal move_down

signal jump
signal dash_short
signal dash_long


func _ready():
	input_controller.input_detected.connect(_on_input_detected)

func _on_input_detected(event: InputEvent, action: String, input_type: InputType):
	match input_type:
		InputType.ACTIVE:
			prints(action, "active")
		InputType.TAP:
			prints(action, "tapped")
		InputType.DOUBLE_TAP:
			prints(action, "double tapped")
		InputType.PRESS:
			prints(action, "pressed")
		InputType.LONG_PRESS:
			prints(action, "long pressed")
		InputType.HOLD:
			prints(action, "held")
