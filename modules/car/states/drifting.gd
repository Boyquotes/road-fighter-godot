extends State

var steering_angle := deg2rad(-75)
var steer_angle := 0.0
var velocity := Vector2.ZERO
var previous_direction := 0.0
var left_skid_mark : Line2D
var right_skid_mark : Line2D

onready var tween = $Tween

func enter(_msg := {}) -> void:
	character.drift_sfx.play()
	previous_direction = character.direction
	
	if not tween.is_connected("tween_all_completed", self, "_skid_marks_vanished"):
		tween.connect("tween_all_completed", self, "_skid_marks_vanished")
	
	left_skid_mark = Line2D.new()
	left_skid_mark.show_behind_parent = true
	left_skid_mark.z_index = -1
	left_skid_mark.begin_cap_mode = Line2D.LINE_CAP_ROUND
	left_skid_mark.end_cap_mode = Line2D.LINE_CAP_ROUND
	left_skid_mark.width = 5
	left_skid_mark.default_color = Color(0.28, 0.28, 0.28)
	
	right_skid_mark = Line2D.new()
	right_skid_mark.show_behind_parent = true
	right_skid_mark.z_index = -1
	right_skid_mark.begin_cap_mode = Line2D.LINE_CAP_ROUND
	right_skid_mark.end_cap_mode = Line2D.LINE_CAP_ROUND
	right_skid_mark.width = 5
	right_skid_mark.default_color = Color(0.28, 0.28, 0.28)
	
	self.add_child(left_skid_mark)
	self.add_child(right_skid_mark)

func update(delta: float) -> void:
	left_skid_mark.add_point(character.rear_left.global_position)
	right_skid_mark.add_point(character.rear_right.global_position)

func physics_update(delta) -> void:
	steer_angle = character.direction * steering_angle
	character.rotation = lerp_angle(character.rotation, steer_angle, delta)
	velocity = Vector2(character.direction * character.velocity/8, -character.velocity)
	velocity = character.move_and_slide(velocity)

func move(dir:Vector2) -> void:
	character.velocity += character.acceleration if dir.y != 0 else -character.acceleration
	character.velocity = clamp(character.velocity, 0.0, character.MAX_DRIFTING_VELOCITY)
	character.direction = dir.x if dir.x != 0 else previous_direction
	previous_direction = character.direction

func exit() -> void:
	character.drift_sfx.stop()
	return
	tween.interpolate_property(left_skid_mark, "modulate:a", left_skid_mark.modulate.a, 0.0, 1.5)
	tween.interpolate_property(right_skid_mark, "modulate:a", right_skid_mark.modulate.a, 0.0, 1.5)
	tween.start()

func _skid_marks_vanished() -> void:
	left_skid_mark.clear_points()
	right_skid_mark.clear_points()
