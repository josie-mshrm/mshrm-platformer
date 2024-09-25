extends AnimatableBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _on_area_2d_body_entered(body: Player) -> void:
	animation_player.play("slide left")
	await get_tree().create_timer(2.0).timeout
	animation_player.play("RESET")
