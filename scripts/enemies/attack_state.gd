extends StateEnemy
class_name AttackStateEnemy

@onready var torpedo: TorpedoStateEnemy = $"../Torpedo"

func on_enter() -> void:
	enemy.is_attack = true
	enemy.velocity.x = 0.0
	enemy.animation_player.play("to_torpedo")

func on_leave_screen() -> void:
	next_state = start_state
	
func on_animation_finised(_anime_name: StringName) -> void:
	if _anime_name == "to_torpedo":
		next_state = torpedo
	
func on_exit() -> void:
	enemy.is_attack = false
