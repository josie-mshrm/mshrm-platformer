class_name Platform
extends AnimatableBody2D

## the target position
@export var target : Marker2D
## the time taken to move from the init position to the target
@export var time : float = 0.5
## the time the platform waits before returning to init position
@export var delay_time : float = 1.0

var init_position : Vector2
var return_time : float
var animation_time : float

@onready var collision: CollisionPolygon2D = $Collision
@onready var timer: Timer = $Timer


func _ready() -> void:
	init_position = self.global_position
	
	return_time = time * 2
	animation_time = time + delay_time + return_time + 0.05 # add small buffer for smoothness
	timer.wait_time = animation_time


func move_platform():
	var tween : Tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	
	## Move the platform to the target
	timer.start()
	tween.tween_property(self, "position", target.global_position, time)
	
	## Wait at the target
	tween.tween_interval(delay_time)
	
	## Return to init position
	tween.tween_property(self, "position", init_position, return_time)


func remote_move_soul(soul: Soul):
	## add the transformer to the platform
	var transformer : RemoteTransform2D = _init_transform2D()
	transformer.global_position = soul.global_position
	transformer.remote_path = transformer.get_path_to(soul)
	
	await timer.timeout
	soul.ray_down.remove_exception(self)
	transformer.queue_free()


func _init_transform2D() -> RemoteTransform2D:
	var transformer = RemoteTransform2D.new()
	transformer.name = &"transformer"
	add_child(transformer)
	transformer.update_position = true
	transformer.update_rotation = false
	transformer.update_scale = false
	return transformer
