class_name Platform
extends AnimatableBody2D

## this signal is emitted when the platform reaches it's desired target
signal target_reached()

## the target position
@export var target : Marker2D
## the desired launch velocity
@export var launch_velocity : int = 3000
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

var offset_target : Node2D
var offset_value := Vector2.ZERO

enum State {HOME, TARGET, MOVING}

@onready var collision: CollisionPolygon2D = $Collision
@onready var area_2d: Area2D = $Area2D
@onready var area_collision: CollisionShape2D = $Area2D/CollisionShape2D
@onready var parent : Node2D = $".."


func _ready() -> void:
	init_position = self.global_position
	
	return_time = time * 2
	animation_time = time + (2 * delay_time) + return_time
	
	GlobalBus.player_input_action.connect(on_player_input)
	area_2d.body_entered.connect(on_body_entered)
	area_2d.body_exited.connect(on_body_exited)
	target_reached.connect(on_target_reached)
	
	current_state = State.HOME


func _physics_process(delta: float) -> void:
	if offset_target != null: # if there is a target
		vertical_offset(offset_target, offset_value.y) # do the vertical offset


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
	pass
	# if the body is the player, calculate the offset and apply

func on_body_exited(body: Node2D):
	pass
	# if the body is the player, disable offset


func on_player_input(action: StringName, event : InputEvent):
	if action == &"jump": # If the player inputs a jump
		if offset_target != null:
			if current_state == State.MOVING: # and the platform is moving
				launch_body(offset_target) # add velocity to player
				offset_target = null # and then stop the offset


func calculate_offset(soul : Soul):
	offset_target = soul
	offset_value.y = offset_target.global_position.y - global_position.y

func vertical_offset(soul : Soul, offset : float):
	soul.global_position.y = global_position.y + offset


func launch_body(soul : Soul):
	soul.velocity.y += launch_velocity * -1


func on_target_reached():
	pass
	#if current_state == State.TARGET:
		#if offset_target != null:
			#launch_body(offset_target) # add velocity to player
			#offset_target = null # and then stop the offset
