extends State
class_name AttackState

func on_enter() -> void:
	player.is_attack = true
	player.velocity.x = 0.0
	player.animation_player.play("attack")
	
func on_exit() -> void:
	player.is_attack = false
