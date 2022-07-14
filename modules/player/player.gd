extends Node2D
class_name Player

signal update_velocity(new_velocity)
signal update_velocity_level(new_velocity_level)

var model : Car

onready var camera = $Camera2D

func _enter_tree() -> void:
	model = load("res://modules/car/car.tscn").instance()
	self.add_child(model)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("next_level"):
		model.increase_velocity_level()
		emit_signal("update_velocity_level", model.current_velocity_level)
	elif Input.is_action_just_pressed("prev_level"):
		model.decrease_velocity_level()
		emit_signal("update_velocity_level", model.current_velocity_level)
	
	if Input.is_action_just_pressed("break"):
		model.transition_to("Drifting")
	elif Input.is_action_just_released("break"):
		model.transition_to("Normal")
	
	model.move(input())
	camera.position = model.position
	emit_signal("update_velocity", model.velocity)

func input() -> Vector2:
	var accelerate = Input.get_action_strength("accelerate")
	var direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	return Vector2(direction, accelerate)
