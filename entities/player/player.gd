extends Soul

class_name Player

var player_actions : Dictionary = {
	"move_left" : InputType.ACTIVE,
	"move_right" : InputType.ACTIVE,
	"move_down" : InputType.ACTIVE,
	"move_up" : InputType.ACTIVE,
	"jump" : InputType.ACTIVE,
	"dash_short" : InputType.ACTIVE,
	"dash_long" : InputType.ACTIVE,
	"wall_grab" : InputType.HOLD,
}

func _ready() -> void:
	actions = player_actions
