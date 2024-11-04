extends State
class_name SquatState

func on_enter() -> void:
	player.is_squat = true
	player.velocity.x = 0.0
	player.animation_player.play("squat")
	
func on_exit() -> void:
	player.is_squat = false
