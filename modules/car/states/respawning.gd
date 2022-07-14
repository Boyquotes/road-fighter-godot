extends State

func enter(_msg := {}) -> void:
	character.anim.play("default")
	character.global_position = character.init_pos
	character.rotation = 0.0
	$AnimationPlayer.play("respawning")
	$RespawnTimer.start()

func _on_RespawnTimer_timeout() -> void:
	character.collision.disabled = false
	$AnimationPlayer.play("RESET")
	state_machine.transition_to("Normal")
