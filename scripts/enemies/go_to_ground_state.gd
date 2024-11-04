extends StateEnemy
class_name GoToGroundStateEnemy

@onready var ground: GroundStateEnemy = $"../Ground"

func on_enter() -> void:
	enemy.is_go_to_ground = true
	enemy.velocity.x = 0.0
	enemy.animation_player.play("go_to_ground")
	
func on_animation_finised(anim_name: StringName) -> void:
	next_state = ground
			
func on_exit() -> void:
	enemy.is_go_to_ground = false
