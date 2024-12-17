class_name GlueObject
extends Node

@export var lock_x : bool = false
@export var lock_y : bool = false

var parent : Node2D = get_parent()
var child : Node2D

var buffer : Dictionary # = {node : last_position}

func _ready() -> void:
	
	buffer.get_or_add(parent, parent.global_position)
	buffer.get_or_add(child, child.global_position)

## Determines the distance from the child to the parent. Returns a vector that
## remains unchanged during run().
func calculate_distance() -> Vector2:
	var distance : Vector2 = Vector2.ZERO
	
	## if the character can only move along the x axis
	if lock_y:
		distance.x = 0
		distance.y = parent.global_position.y - child.global_position.y
	
	## if the character can only move along the y axis
	if lock_x:
		distance.y = 0
		distance.x = parent.global_position.x - child.global_position.x
	
	return distance

func _physics_process(delta: float) -> void:
	run_glue(delta)

## Call this function in the _physics_process() to activate the glue.
func run_glue(_delta : float):
	# calculate the change in position since the last frame
	var parent_delta = parent.global_position - buffer[parent]
	#var child_delta = child.global_position - buffer[child]
	
	# add the parent_delta to the child
	child.global_position += parent_delta
	
	# set the locked parameters to be the buffered value
	
	# buffer the last parent position and last child position
	buffer[parent] = parent.global_position
	buffer[child] = child.global_position
