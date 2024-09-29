extends Node
class_name Controller

@export var child : Soul

signal send_action(action)

var soul_action: String

enum InputType {
	ACTIVE,
	TAP,
	DOUBLE_TAP,
	PRESS,
	LONG_PRESS,
	HOLD,
	CANCEL,
}
