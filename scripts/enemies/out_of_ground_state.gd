extends StateEnemy
class_name OutOfGroundStateEnemy

func on_enter() -> void:
	enemy.is_out_of_ground = true
	enemy.velocity.x = 0.0
	enemy.animation_player.play("out_of_ground")
	
func on_exit() -> void:
	enemy.is_out_of_ground = false
