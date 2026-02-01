extends CharacterBody2D


const SPEED = 30.0

@onready var nav: NavigationAgent2D = $NavigationAgent2D

# TODO: Don't get first, get nearest instead. Shouldn't matter unless more stuff is considered a "player", eg. decoy etc.
var player: CharacterBody2D

func _ready() -> void:
	actor_setup.call_deferred()
	nav.velocity_computed.connect(_velocity_computed)

func actor_setup():
	await get_tree().physics_frame
	player = get_tree().get_first_node_in_group("player")
	
	set_movement_target(player.position)

func set_movement_target(movement_target: Vector2):
	nav.target_position = movement_target

func _physics_process(delta: float) -> void:
	_move_towards_player()
	
func _move_towards_player():
	if not player:
		return
	set_movement_target(player.position)
	
	if nav.is_navigation_finished():
		return
		
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = nav.get_next_path_position()
	
	var new_velocity = current_agent_position.direction_to(next_path_position) * SPEED
	
	if nav.avoidance_enabled:
		nav.set_velocity(new_velocity)
	else:
		_velocity_computed(new_velocity)
		
	move_and_slide()
	
func _velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
