extends StateEnemy
class_name TorpedoStateEnemy

func on_enter() -> void:
	enemy.is_torpedo = true
	enemy.animation_player.play("torpedo")
	
func on_leave_screen() -> void:
	next_state = start_state
	
func on_exit() -> void:
	enemy.position.y = enemy.original_position.y
	enemy.is_torpedo = false
