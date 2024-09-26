class_name OrbHolder
extends Node2D

func _ready() -> void:
	get_parent().rotation_changed.connect(on_rotation_changed)
	
func on_rotation_changed(angle):
	pass
	#self.global_rotation = angle
