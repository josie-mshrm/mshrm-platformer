extends RigidBody2D

@export var distance : Vector2
@export var time : float
@export var reset: Marker2D

var force : Vector2
var is_moving : bool = false

func _ready() -> void:
	set_force()

func _physics_process(delta: float) -> void:
	if is_moving:
		apply_central_force(force)

func _on_area_2d_body_entered(body: Player) -> void:
	is_moving = true
	set_force()
	await get_tree().create_timer(time).timeout
	launch_body(body)
	end_movement()

func _on_area_2d_body_exited(body: Node2D) -> void:
	launch_body(body)

func set_force() -> Vector2:
	force = ((distance/time)/time) * 10
	return force

func end_movement():
	is_moving = false
	self.freeze = true
	force = Vector2.ZERO
	await get_tree().create_timer(.1).timeout
	self.position = reset.position
	self.freeze = false

func launch_body(soul: Soul):
	if soul is Player:
		soul.velocity += set_force()
