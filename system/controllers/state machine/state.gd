extends Node
class_name State

signal transitioned

var parent_soul: Soul
var is_input_paused: bool = false

func enter():
	pass

func exit():
	pass

func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass

func input_pause(time):
	is_input_paused = true
	await get_tree().create_timer(time).timeout
	is_input_paused = false
