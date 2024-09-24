class_name AreaDamageModule
extends Area2D

@export var damage: int = 10

func _ready() -> void:
	pass
	
# Check if player entered area
# call damage on player
# damage is set by parent, so will need reference to the parent
