class_name Platform
extends AnimatableBody2D

## this signal is emitted when the platform reaches it's desired target
signal target_reached(target)

## the target position
@export var target : Marker2D
## the time taken to move from the init position to the target
@export var time : float = 0.5
## the time the platform waits before returning to init position
@export var delay_time : float = 1.0
@export var ease : Tween.EaseType
@export var trans : Tween.TransitionType
@export var process : Tween.TweenProcessMode

var init_position : Vector2
var return_time : float
var animation_time : float
var current_state : State

enum State {HOME, TARGET, MOVING}

@onready var collision: CollisionPolygon2D = $Collision
@onready var area_2d: Area2D = $Area2D
@onready var area_collision: CollisionShape2D = $Area2D/CollisionShape2D
@onready var parent : Node2D = $".."


func _ready() -> void:
	init_position = self.global_position
	
	return_time = time * 2
	animation_time = time + (2 * delay_time) + return_time
	
	area_2d.body_entered.connect(on_body_entered)
	area_2d.body_exited.connect(on_body_exited)
	
	current_state = State.HOME


func move_platform():
	var tween : Tween = create_tween()
	tween.set_process_mode(process)
	tween.set_ease(ease)
	tween.set_trans(trans)
	
	
	## Move the platform to the target
	tween.tween_callback(set_state.bind(State.MOVING))
	tween.tween_property(self, "position", target.global_position, time)

	## Wait at the target
	tween.tween_callback(set_state.bind(State.TARGET))
	tween.tween_callback(target_reached.emit)
	tween.tween_interval(delay_time)
	
	## Return to init position
	tween.tween_callback(set_state.bind(State.MOVING))
	tween.tween_property(self, "position", init_position, return_time)
	
	## Wait at home
	tween.tween_interval(delay_time)
	tween.tween_callback(set_state.bind(State.HOME))
	tween.tween_callback(target_reached.emit)


func set_state(state: State):
	current_state = state


func on_body_entered(body: Node2D):
	if body is Player:
		body.movement_tree.gravity_mod = 4.0


func on_body_exited(body: Node2D):
	if body is Player:
		body.movement_tree.gravity_mod = 1.0
