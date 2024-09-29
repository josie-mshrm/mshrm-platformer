extends Controller
class_name PlayerController


@export var input_controller: InputController
#const InputType = InputController.InputType

func _ready():
	input_controller.input_detected.connect(_on_input_detected)

func _on_input_detected(event: InputEvent, action: String, input_type: InputType):
	soul_action = action
	if input_type == InputType.ACTIVE:
		send_action.emit(soul_action)
	
	
	#match input_type:
		#InputType.ACTIVE:
			#prints(action, "active")
		#InputType.TAP:
			#prints(action, "tapped")
		#InputType.DOUBLE_TAP:
			#prints(action, "double tapped")
		#InputType.PRESS:
			#prints(action, "pressed")
		#InputType.LONG_PRESS:
			#prints(action, "long pressed")
		#InputType.HOLD:
			#prints(action, "held")
