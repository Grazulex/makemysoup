extends StateEnemy
class_name OutOfGroundStateEnemy

@onready var idle: IdleStateEnemy = $"../Idle"

func on_enter() -> void:
	enemy.is_out_of_ground = true
	enemy.velocity.x = 0.0
	enemy.animation_player.play("out_of_ground")
	
func on_animation_finised(anim_name: StringName) -> void:
	next_state = idle
		
func on_exit() -> void:
	enemy.is_out_of_ground = false
