extends Area2D
class_name HitboxModule
# This component takes damage and applies it to the health component

@export var health: HealthModule

func damage(attack: Attack) -> float:
	health.damage(attack)
	return health.health
