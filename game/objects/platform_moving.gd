class_name Platform
extends AnimatableBody2D

@export var target : Marker2D
#@export_enum("Looping", "On Enter", "Instant") var type
enum MoveType {ENTER, LOOPING, INSTANT}
@export var type : MoveType = MoveType.ENTER
## the time taken to move from the init position to the target
@export var time : float = 0.5
## the time the platform waits before returning to init position
@export var delay_time : float = 1.0

var init_position : Vector2
var animation_time : float

@onready var collision: CollisionPolygon2D = $Collision
@onready var area: Area2D = $Area

func _ready() -> void:
	init_position = self.global_position
	animation_time = time + delay_time + (time * 2)
	if type == MoveType.ENTER:
		area.body_entered.connect(on_body_entered)

func on_body_entered(body : Soul):
	print("entered")
	if body is Player:
		area_cooldown(animation_time)
		move_platform()

func area_cooldown(area_time : float):
	area.set_deferred("monitoring", false)
	await get_tree().create_timer(area_time).timeout
	print("done")
	area.set_deferred("monitoring", true)

func move_platform():
	var tween = create_tween()
	
	## Move the platform and wait
	tween.tween_property(self, "position", target.global_position, time)
	tween.tween_interval(delay_time)
	## Return to init position
	tween.tween_property(self, "position", init_position, time * 2)
	
