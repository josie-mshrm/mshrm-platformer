class_name FiringComponent
extends Node2D
## This component creates and fires bullets


@export var fire_freq: float = 0.2
@export var orb_load: Orb
@export var orb_holder: Node2D
@export var orb_type: Node2D


@onready var fire_rate: Timer = $"fire rate"

var is_firing = false
var self_target: Soul

func _ready():
	pass

func _physics_process(delta: float) -> void:
	if fire_rate.is_stopped() == true and is_firing == true: # if the timer is not currently running and the fire button is being held
		fire_rate.start(fire_freq) # start the firing timer
	elif is_firing == false: # if the timer is running
		fire_rate.stop() # stop the timer

## Enables the component to fire at the given target
func enable_fire(target):
	self_target = target
	is_firing = true

func disable_fire():
	is_firing = false

## Timer function for firing the orb
func _on_fire_rate_timeout() -> void:
	fire_orb(self_target)


func fire_orb(target: Node2D):
	if target.is_queued_for_deletion(): # if the target doesn't exist or will be deleted
		print("Not Valid Target")
		return
	
	var orb_inst = orb_type.instantiate()
	orb_holder.add_child(orb_inst)
	orb_inst.global_position = self.global_position
	#print("Firing at " + str(target))
	
	orb_inst.fire(target)

func on_target_found(parent_target):
	#print("Target " + str(parent_target) + " has been found")
	enable_fire(parent_target)

func on_tower_rotation(angle):
	pass
