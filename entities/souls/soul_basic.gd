extends Soul

var direction = Vector2.LEFT

func _physics_process(delta: float) -> void:
	velocity = speed * direction * delta
	
	move_and_collide(velocity)


#func _on_movement_component_directional_movement(direction: Variant) -> void:
	#
	#if direction != Vector2.ZERO:
		#force_direction = direction
	#else:
		#force_direction = Vector2.ZERO
