class_name MovementTree
extends MoveBranch

@export_group("Movement Stats")
@export var accel_time : float = 0.25
@export var decel_rate : float = 0.65
@export var jumps: int = 3
@export var jump_height: float = 25.0
@export var jump_peak_time: float = 0.4
@export var jump_fall_time: float = 0.3
@export var min_jump_time: float = 0.15
@export var coyote_time: float = 0.25
@export var buffer_time: float = 0.15
@export var wall_slide_speed: int = 200
## The wall kick angle in degrees, 0 degrees is straight up
@export var wall_kick_angle: int = 30
@export var wall_kick_force: int = 1200

var gravity : Vector2
var project_gravity
var gravity_mod : float = 1.0
var max_velocity : int
var accel : float
var jump_counter: int = 0
var jump_velocity: float
var jump_gravity: float
var fall_gravity: float

var is_jump : bool = false
var is_coyote : bool = false
var state : MoveState = null
var last_state : MoveState = null

var input_buffer : Dictionary = {
	&"jump" : false, 
	}
var buffer_active : bool = false
var ray_down : RayCast2D
var ray_left : RayCast2D
var ray_right : RayCast2D

@onready var ground_branch: GroundBranch = $GroundBranch
@onready var air_branch: AirBranch = $AirBranch
@onready var wall_branch: WallBranch = $WallBranch



func _ready() -> void:
	soul = $".."
	
	GlobalBus.player_input_action.connect(on_player_input)
	
	soul.platform_hit.connect(on_platform_hit)
	
	project_gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * ProjectSettings.get_setting("physics/2d/default_gravity_vector")
	gravity = project_gravity
	
	# Node and variable initialization
	calc_jump_var()
	max_velocity = (2 ** 11) * soul.speed
	accel = max_velocity / accel_time
	
	# Passing reference for self and soul to movement system
	for child in get_children():
		if child is MoveBranch:
			child.soul = soul
			child.host = self


func _setup() -> void:
	get_raycast_nodes()
	
	add_transition(ANYSTATE, ground_branch, &"ground")
	add_transition(ANYSTATE, air_branch, &"air")
	add_transition(ANYSTATE, wall_branch, &"wall")
	add_transition(ground_branch, air_branch, &"fall")


func _update(delta: float) -> void:
	## Apply gravity
	soul.velocity += gravity * delta * gravity_mod
	
	## Moving platform detection
	if ray_down.is_colliding():
		var collider = ray_down.get_collider()
		if collider is Platform:
			soul.platform_hit.emit(collider)
	
	soul.move_and_slide()


## Function for changing state based on player inputs
func on_player_input(action: StringName, event : InputEvent):
	
	if action == &"jump":
		
		# If the Air or Wall branches are active, dispatch the action
		# If failed, buffer the input
		if air_branch.is_active():
			if dispatch(&"jump"):
				pass
			else:
				buffer_input(action, event)
		elif wall_branch.is_active():
			if dispatch(&"wall kick"):
				pass
			else:
				buffer_input(action, event)
		elif ground_branch.is_active():
			is_jump = true
			dispatch(&"air")


## Function for moving the character on the x axis based on player input, including a modifier for the speed of movement
func move_character_x(delta: float, state_mod: float):
	# if there is an input being pressed
	if soul.input_direction.x != 0: 
		if absf(soul.velocity.x) < max_velocity:
			soul.velocity.x += accel * delta * sign(soul.input_direction.x) * state_mod
		else:
			soul.velocity.x = max_velocity * sign(soul.input_direction.x) * state_mod
	
	# if there is no input
	else: 
		var abs_velocity : float = absf(soul.velocity.x)
		# if the velocity is less than 15% of the max velocity
		if abs_velocity <= max_velocity * 0.15:
			if abs_velocity < 20:
				soul.velocity.x = 0
			else:
				var sign_velocity : int = sign(soul.velocity.x)
				if sign_velocity == 1:
					soul.velocity.x -= 10
				elif sign_velocity == -1:
					soul.velocity.x += 10
		else:
			soul.velocity.x *= decel_rate


func on_platform_hit(platform: Platform):
	ray_down.add_exception(platform)
	
	# Move the platform
	platform.calculate_offset(soul)
	platform.move_platform()
	
	await platform.target_reached
	if platform.current_state == platform.State.TARGET:
		platform.launch_body(soul)
		platform.offset_target = null
	
	while platform.current_state != platform.State.HOME:
		await platform.target_reached
	
	
	ray_down.remove_exception(platform)


func calc_jump_var():
	jump_velocity = ((2.0 * jump_height) / jump_peak_time) * -10.0
	jump_gravity = ((-2.0 * jump_height) / (jump_peak_time * jump_peak_time)) * -10.0
	fall_gravity = ((-2.0 * jump_height) / (jump_fall_time * jump_fall_time)) * -10.0


func get_tree_state() -> MoveState:
	last_state = state
	state = get_leaf_state()
	return state


## Checks whether the character is in a viable state to perform the jump
func can_jump() -> bool:
	if jump_counter >= jumps:
		return false
	else:
		return true


func buffer_input(action: StringName, event: InputEvent):
	#if something is already in the buffer, clear it first
	if buffer_active:
		input_buffer.erase(action)
	
	buffer_active = true
	input_buffer[action] = event
	await get_tree().create_timer(buffer_time, true, true, false).timeout
	input_buffer.erase(action)
	buffer_active = false


func check_buffer(action : StringName) -> bool:
	if input_buffer.has(action):
		var event = input_buffer[action]
		
		if event is InputEvent:
			if Input.is_action_pressed(action):
				input_buffer.erase(action)
				return true
	return false


func get_raycast_nodes():
	ray_down = soul.soul_raycast_dict.get(&"RayDown")
	ray_left = soul.soul_raycast_dict.get(&"RayLeft")
	ray_right = soul.soul_raycast_dict.get(&"RayRight")
