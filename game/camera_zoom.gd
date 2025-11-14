extends Camera2D

# How far can you zoom out, 1 meaning no zoom is applied
@export_range(1, 5) var minimum_zoom_level := 1.0
# How close can you zoom in
@export_range(1, 5) var maximum_zoom_level := 5.0
# How much do we increase zoom per event
@export_range(0, 1) var zoom_sensitivity := 0.1

var current_zoom_level := minimum_zoom_level

func increase_zoom():
	var zoom_level = current_zoom_level + zoom_sensitivity;
	if zoom_level <= maximum_zoom_level:
		update_current_zoom(zoom_level)
	
func decrease_zoom():
	var zoom_level = current_zoom_level - zoom_sensitivity;
	if zoom_level >= minimum_zoom_level:
		update_current_zoom(zoom_level)
	
func update_current_zoom(zoom_level):
	current_zoom_level = zoom_level
	set_zoom(Vector2(current_zoom_level, current_zoom_level))

func try_set_zoom(zoom_level):
	if minimum_zoom_level <= zoom_level and zoom_level <= maximum_zoom_level:
		set_zoom(Vector2(zoom_level, zoom_level))

func _ready() -> void:
	try_set_zoom(current_zoom_level)

func _input(event):
	if event.is_action_pressed("ui_zoom_in"):
		increase_zoom()
	if event.is_action_pressed("ui_zoom_out"):
		decrease_zoom()
