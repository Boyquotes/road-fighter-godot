extends KinematicBody2D
class_name Car

const VELOCITY_LEVELS = [200.0, 400.0, 800.0]

export var velocity : float = 0.0
export var acceleration : float = 5.0

var MAX_VELOCITY : float = VELOCITY_LEVELS[0]
var MAX_DRIFTING_VELOCITY : float = MAX_VELOCITY / 4.0
var current_velocity_level : int = 0

var direction : float = 0.0
var init_pos := Vector2.ZERO

onready var anim = $Animations
onready var tween = $Tween
onready var area = $Area2D
onready var collision = $Area2D/Collision
onready var state_machine = $States
onready var rear_left = $RearLeft
onready var rear_right = $RearRight
onready var running_sfx = $SFX/Running
onready var drift_sfx = $SFX/Drift
onready var explosion_sfx = $SFX/Explosion

func _ready() -> void:
	area.set_meta("type", "car")
	init_pos = global_position

func set_velocity_level(level : int) -> void:
	MAX_VELOCITY = VELOCITY_LEVELS[level]
	MAX_DRIFTING_VELOCITY = MAX_VELOCITY / 4.0

func increase_velocity_level() -> void:
	current_velocity_level += 1
	current_velocity_level = clamp(current_velocity_level, 0, VELOCITY_LEVELS.size() - 1)
	set_velocity_level(current_velocity_level)

func decrease_velocity_level() -> void:
	current_velocity_level -= 1
	current_velocity_level = clamp(current_velocity_level, 0, VELOCITY_LEVELS.size() - 1)
	decrease_velocity(VELOCITY_LEVELS[current_velocity_level])
	yield(get_tree().create_timer(1.5), "timeout")
	set_velocity_level(current_velocity_level)

func transition_to(state : String, msg: Dictionary = {}) -> void:
	var current_state : String = state_machine.state.name
	if current_state != state:
		if current_state != "Exploded" and current_state != "Respawning":
			state_machine.transition_to(state, msg)

func move(dir : Vector2) -> void:
	state_machine.state.move(dir)

func crash(orientation : int) -> void:
	tween.interpolate_property(self, "velocity", velocity, 0.0, 1.5)
	tween.interpolate_property(self, "position:x", self.position.x, self.position.x + 150 * orientation, 1.5)
	tween.interpolate_property(self, "rotation_degrees", self.rotation_degrees, 360 * orientation, 1.5)
	tween.start()

func decrease_velocity(to : float) -> void:
	if velocity > to:
		tween.interpolate_property(self, "velocity", velocity, to, 1.5)
		tween.start()

func reset_velocity(time : float) -> void:
	tween.interpolate_property(self, "velocity", velocity, 0.0, time)
	tween.start()

func _on_Area2D_area_entered(other_area: Area2D) -> void:
	match other_area.get_meta("type", "none"):
		"car":
			crash(1 if other_area.global_position.x < self.area.global_position.x else -1)
		"border":
			state_machine.transition_to("Exploded")

func _on_Area2D_body_entered(body: Node) -> void:
	state_machine.transition_to("Exploded")
