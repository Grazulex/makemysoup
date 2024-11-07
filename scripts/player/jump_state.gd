extends State
class_name JumpState

@export var jump_velocity : float = -900.0

func on_enter() -> void:
	player.is_jumping = true
	player.velocity.y = jump_velocity
	player.animation_player.play("jump")
	
func on_exit() -> void:
	player.is_jumping = false
