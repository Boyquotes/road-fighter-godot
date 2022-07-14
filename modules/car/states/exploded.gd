extends State

func enter(_msg := {}) -> void:
	character.running_sfx.stop()
	character.explosion_sfx.play()
	character.collision.call_deferred("set", "disable", true)
	character.anim.play("explosion")
	$ExplosionTimer.start()
	character.reset_velocity(2.0)

func _on_ExplosionTimer_timeout() -> void:
	state_machine.transition_to("Respawning")
