class_name Controller
extends Node
## This class is for character controllers that send single commands to the Soul
## that this is the parent for.



## The vector for the character's movement
var ctrl_move_dir : Vector2 = Vector2.ZERO

enum InputType {
	ACTIVE,
	TAP,
	DOUBLE_TAP,
	PRESS,
	LONG_PRESS,
	HOLD,
	CANCEL,
}
