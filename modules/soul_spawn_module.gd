extends Node2D

var soul_basic
#this should be a constant with the node to the thing being spawned

@onready var orb_holder: Node2D = $/root/main/OrbHolder
@onready var soul_holder: Node2D = $/root/main/SoulHolder
@onready var spawn_timer: Timer = $spawn_timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer.start()
	#print("start")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spawn_timer_timeout() -> void:
	spawn_soul()
	
func spawn_soul():
	var soul = soul_basic.instantiate()
	soul_holder.add_child(soul)
	soul.global_position = self.global_position
	#print("soul spawned")
