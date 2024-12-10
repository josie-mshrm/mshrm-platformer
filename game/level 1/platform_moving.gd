class_name Platform
extends AnimatableBody2D

@export var target : Marker2D
#@export_enum("Looping", "On Enter", "Instant") var type
enum MoveType {ENTER, LOOPING, INSTANT}
@export var type : MoveType = MoveType.ENTER
@export var time : float = 0.5
@export var delay_time : float = 1.0

var init_position : Vector2

@onready var collision: CollisionPolygon2D = $Collision
@onready var area: Area2D = $Area

func _ready() -> void:
	if type == MoveType.ENTER:
		area.body_entered.connect(on_body_entered)

func on_body_entered(body : Soul):
	print("entered")
	if body is Player:
		move_platform()

func move_platform():
	init_position = self.global_position
	var tween = create_tween()
	tween.tween_property(self, "position", target.global_position, time)
	tween.tween_interval(delay_time)
	tween.tween_property(self, "position", init_position, time * 2)
	
