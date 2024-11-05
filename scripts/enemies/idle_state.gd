extends StateEnemy
class_name IdleStateEnemy

func on_enter() -> void:
	enemy.is_idle = true
	enemy.velocity.x = 0.0
	enemy.animation_player.play("idle")

func on_leave_screen() -> void:
	next_state = start_state
	
func on_exit() -> void:
	enemy.is_idle = false
