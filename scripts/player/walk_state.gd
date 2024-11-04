extends State
class_name WalkState

@export var speed : float = 650.0

var direction : float

func on_enter() -> void:
	player.is_walking = true
	player.velocity.x = direction * speed
	player.animation_player.play("walk")
	
func on_exit() -> void:
	player.is_walking = false

func set_direction(new_direction: float) -> void:
	direction = new_direction
