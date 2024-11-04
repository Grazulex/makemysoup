extends StateEnemy
class_name GroundStateEnemy

@onready var out_of_ground: OutOfGroundStateEnemy = $"../OutOfGround"

func on_enter() -> void:
	enemy.is_ground = true
	enemy.velocity.x = 0.0
	enemy.animation_player.play("ground")
	
func on_exit() -> void:
	enemy.is_ground = false

func on_visible_on_screen() -> void:
	next_state = out_of_ground
	
