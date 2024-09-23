class_name Orb
extends Node2D

@onready var orb_area: HitboxModule
@onready var orb_holder: Node2D

@export var speed: int
@export var tracking: bool

var orb_target: Node2D
var last_target_direction: Vector2
var target_direction: Vector2

var output_damage = 4

func _ready() -> void:
	orb_holder = get_parent()

func _physics_process(delta: float) -> void:
	## If tracking, find the position of the target every frame
	## If not tracking, find the position of the target at the time of fire() call. 
	if tracking and is_instance_valid(orb_target): # if the target exists, use that position. otherwise use the unit vector of the top tower rotation.
		last_target_direction = find_target_direction(orb_target)
	else:
		target_direction = last_target_direction
	
	position += target_direction * speed * delta


## Recieves a target and assigns it to the orb. 
func fire(target: Node2D):
	#print("target is: " + str(target))
	orb_target = target
	if not tracking:
		last_target_direction = find_target_direction(orb_target)

## Finds the target vector of the given target
func find_target_direction(target: Node2D) -> Vector2:
	target_direction = self.global_position.direction_to(target.global_position)
	return target_direction


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area is HitboxModule:
		var hitbox : HitboxModule = area
		var target_health
		var attack = Attack.new()
		attack.attack_damage = output_damage
		
		#print("hit")
		target_health = hitbox.damage(attack)
		print(target_health)
		
		queue_free()
