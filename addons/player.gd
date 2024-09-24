extends CharacterBody2D



@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var world_bound: StaticBody2D = $"../WorldBound"
@onready var player_spawn: Node2D = $"../PlayerSpawn"

@export var speed: float
@export var jump_height: float
@export var jump_peak_time: float
@export var jump_fall_time: float
@export var min_jump_time: float

var jump_velocity: float
var jump_gravity: float
var fall_gravity: float

var direction : float
var jump_grav : float
var release_time: float = 0

enum State {GROUND, RUNNING, JUMPING, FALLING}
var state: int

func _ready() -> void:
	velocity = Vector2.ZERO
	
	jump_velocity = ((2.0 * jump_height) / jump_peak_time) * -1.0
	jump_gravity = ((-2.0 * jump_height) / (jump_peak_time * jump_peak_time)) * -1.0
	fall_gravity = ((-2.0 * jump_height) / (jump_fall_time * jump_fall_time)) * -1.0
	
	set_state(State.GROUND)
	

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("jump") and is_on_floor():
			jump()
			release_time = 0
		
		elif event.is_action_released("jump") and state == State.JUMPING:
			end_jump()


func _physics_process(delta: float) -> void:
	# TODO renable collision box for world bound and add kill zone
	if self.global_position.y >= world_bound.global_position.y:
		self.global_position = player_spawn.global_position
	
	if velocity.y < 0:
		jump_grav = jump_gravity
	else:
		jump_grav = fall_gravity
	
	velocity.x = get_input_direction() * speed
	velocity.y += jump_grav * delta
	
	if is_on_floor() and state != State.GROUND and velocity.y >= 0:
		set_state(State.GROUND)
	
	if state == State.JUMPING:
		release_time += delta
		if not Input.is_action_pressed("jump") and release_time > min_jump_time:
			end_jump()
			print(release_time)
	
	move_and_slide()

func _process(_delta):
	pass

func set_state(new_state):
	var state_name = State.keys()[new_state]
	print("Changing state to " + state_name)
	state = new_state

func jump():
	velocity.y = jump_velocity
	set_state(State.JUMPING)

func end_jump():
	if release_time > min_jump_time:
		velocity.y = 0
		jump_grav = fall_gravity
		set_state(State.FALLING)

func get_input_direction():
	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_axis("left", "right")
	
	return direction

func animation_control():
	# Control Animations
	if is_on_floor(): # If the player is on the floor
		if direction == 0:
			player_sprite.play("idle")
			state = State.GROUND
		else:
			player_sprite.play("run")
			state = State.RUNNING
	else: 
		player_sprite.play("jump") # the player is in the air
	
	# Flip Sprite based on direction
	if direction > 0:
		player_sprite.flip_h = false
	elif direction < 0:
		player_sprite.flip_h = true
