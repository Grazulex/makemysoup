extends State
class_name DamagedState

func on_enter() -> void:
	player.is_damaged = true
	player.velocity.x = 0.0
	player.animation_player.play("damaged")
	
func on_exit() -> void:
	player.is_damaged = false
