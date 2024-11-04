extends State
class_name FallingState

func on_enter() -> void:
	player.is_falling = true
	player.velocity.x = 0.0
	player.animation_player.play("falling")
	
func on_exit() -> void:
	player.is_falling = false
