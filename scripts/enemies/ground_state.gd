extends StateEnemy
class_name GroundStateEnemy

func on_enter() -> void:
	enemy.is_ground = true
	enemy.velocity.x = 0.0
	enemy.animation_player.play("ground")
	
func on_exit() -> void:
	enemy.is_ground = false
