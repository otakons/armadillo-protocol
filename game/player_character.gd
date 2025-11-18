extends CharacterBody2D

##Speed in pixels per second
@export_range(0, 1000) var speed := 60
@onready var _animation_player = $AnimatedSprite2D
func _physics_process(_delta: float) -> void:
	get_player_input()
	move_and_slide()
	if get_local_mouse_position().x < 0:
		_animation_player.flip_h = true
	else:
		_animation_player.flip_h = false
		
	if velocity.length_squared() > 0: 
		_animation_player.play("default")
	else:
		_animation_player.stop()
func get_player_input() -> void:
	var vector := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = vector * speed
