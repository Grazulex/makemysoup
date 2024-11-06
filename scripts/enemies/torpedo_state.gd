extends StateEnemy
class_name TorpedoStateEnemy

@export var speed : float = 600.0

func on_enter() -> void:
	enemy.is_torpedo = true
	enemy.animation_player.play("torpedo")
	
func process(_delta: float, _player : CharacterBody2D) -> void:
	enemy.velocity = enemy.position.direction_to(Global.target_position) * speed
	enemy.move_and_slide()
	
func on_body_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		var player = area.get_parent()
		player.attacked.emit(enemy.damage)
	
func on_leave_screen() -> void:
	next_state = start_state
	
func on_exit() -> void:
	enemy.position.y = Global.original_position.y
	enemy.is_torpedo = false
