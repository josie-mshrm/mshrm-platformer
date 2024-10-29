class_name ActionList
extends Resource

@export var MovementActions : Array[StringName]
@export var AttackActions : Array[StringName]

var ActionDict : Dictionary = {}

func set_action_dict() -> void:
	for action in MovementActions:
		ActionDict.get_or_add(action, "Movement")
	
	for action in AttackActions:
		ActionDict.get_or_add(action, "Attack")
