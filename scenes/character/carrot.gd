extends Enemy

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer

@onready var state_machine: EnemyStateMachine = $EnemyStateMachine

@onready var ground: GroundStateEnemy = $EnemyStateMachine/Ground

var is_ground : bool = true
var is_out_of_ground : bool = false
var is_idle : bool = false
var is_go_to_ground : bool = false

func _ready() -> void:
	state_machine.switch_state(ground)

func _on_body_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		print("collision player")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	state_machine.current_state.on_animation_finised(anim_name)

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	state_machine.current_state.on_visible_on_screen()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	state_machine.current_state.on_leave_screen()
