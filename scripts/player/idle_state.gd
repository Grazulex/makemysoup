extends State
class_name IdleState

func on_enter() -> void:
	player.is_idle = true
	player.velocity.x = 0.0
	player.animation_player.play("idle")
	
func on_exit() -> void:
	player.is_idle = false
