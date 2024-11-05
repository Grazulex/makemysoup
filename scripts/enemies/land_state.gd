extends StateEnemy
class_name LandStateEnemy

@onready var idle: IdleStateEnemy = $"../Idle"

func on_enter() -> void:
	enemy.is_landing = true
	enemy.velocity.x = 0.0
	enemy.animation_player.play("from_torpedo")

func on_leave_screen() -> void:
	next_state = start_state
	
func on_animation_finised(_anime_name: StringName) -> void:
	next_state = idle
	
func on_exit() -> void:
	enemy.is_landing = false
