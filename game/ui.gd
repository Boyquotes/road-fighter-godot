extends Control

onready var fps_label = $Frames
onready var velocity_label = $VelocityLabel
onready var velocity_levels = $VelocityLevels

var current_velocity_level : int = 0

func _process(delta: float) -> void:
	fps_label.text = "%.2f fps" % Engine.get_frames_per_second()

func _on_update_velocity(new_velocity: float) -> void:
	velocity_label.text = "%.2f km/h" % new_velocity

func _on_update_velocity_level(new_velocity_level: int) -> void:
	var prev_level_label = velocity_levels.get_child(current_velocity_level) as Label
	prev_level_label.modulate = Color("#626262")
	
	var level_label = velocity_levels.get_child(new_velocity_level) as Label
	level_label.modulate = Color.white
	current_velocity_level = new_velocity_level
