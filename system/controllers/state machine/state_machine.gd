class_name StateMachine
extends Node

@export var initial_state: State
@export var parent: Soul

var current_state : State
var states : Dictionary = {}


@onready var statetext: Label = $statetext


func _ready() -> void:
	#get a list of possible signals
	#loop through the list, connect to the signal
	
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transitioned)
			child.parent_soul = parent
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
	
	statetext.text = str(current_state)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func on_child_transitioned(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	
	current_state = new_state
