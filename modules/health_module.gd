class_name HealthModule
extends Node


@export var soul: Soul

var health: float

func _ready() -> void:
	health = soul.max_health

func damage(attack: Attack):
	health -= attack.attack_damage
	
	if health <= 0:
		print("death")
		get_parent().queue_free()
