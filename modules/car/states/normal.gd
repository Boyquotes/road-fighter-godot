extends State

var steering_angle := deg2rad(15)
var steer_angle := 0.0
var velocity := Vector2.ZERO

func enter(_msg := {}) -> void:
	character.running_sfx.play()

func physics_update(delta) -> void:
	steer_angle = character.direction * steering_angle
	character.rotation = lerp_angle(character.rotation, steer_angle, 0.25)
	velocity = Vector2(character.direction * character.velocity / 4, -character.velocity)
	velocity = character.move_and_slide(velocity)

func move(dir:Vector2) -> void:
	character.velocity += character.acceleration if dir.y != 0 else -character.acceleration
	character.velocity = clamp(character.velocity, 0.0, character.MAX_VELOCITY)
	character.direction = dir.x
	character.running_sfx.volume_db += 5.0 if dir.y != 0 else -0.5
	character.running_sfx.volume_db = clamp(character.running_sfx.volume_db, -80.0, 0.0)
