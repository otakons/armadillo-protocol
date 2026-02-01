extends CharacterBody2D


@export_range(0, 100) var speed = 50
@export_range(0, 500) var detection_radius = 200

# Base walking speed where animation looks alright (at 5fps)
const BASE_SPEED = 25.0

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var _animation_player = $AnimatedSprite2D

# TODO: Don't get first, get nearest instead. Shouldn't matter unless more stuff is considered a "player", eg. decoy etc.
var player: CharacterBody2D

var debug: bool = false

func _ready() -> void:
	actor_setup.call_deferred()
		
	nav.velocity_computed.connect(_velocity_computed)

func _process(float):
	if Input.is_action_just_pressed("ui_toggle_debug"):
		debug = not debug

func actor_setup():
	await get_tree().physics_frame
	player = get_tree().get_first_node_in_group("player")
	
	set_movement_target(player.position)

func set_movement_target(movement_target: Vector2):
	nav.target_position = movement_target

func _physics_process(delta: float) -> void:
	_adjust_animation_speed()
	_move_towards_player()
	
func _move_towards_player():
	if not player:
		return
		
	if player.position.distance_to(global_position) > detection_radius:
		_animation_player.play("idle")
		return
		
	set_movement_target(player.position)
	_face_towards_player()
	
	if nav.is_navigation_finished():
		_animation_player.play("idle")
		return
	_animation_player.play("walk")
		
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = nav.get_next_path_position()
	
	var new_velocity = current_agent_position.direction_to(next_path_position) * speed
	
	if nav.avoidance_enabled:
		nav.set_velocity(new_velocity)
	else:
		_velocity_computed(new_velocity)
		
	move_and_slide()
	
func _face_towards_player():
	var flipped = (player.position.x - global_position.x) > 0
	_animation_player.flip_h = flipped

func _adjust_animation_speed():
		var animation_multiplier = speed / BASE_SPEED
		_animation_player.speed_scale = animation_multiplier

	
func _velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
