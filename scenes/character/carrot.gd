extends Enemy

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer

@onready var state_machine: EnemyStateMachine = $EnemyStateMachine

@onready var ground: GroundStateEnemy = $EnemyStateMachine/Ground
@onready var out_of_ground: OutOfGroundStateEnemy = $EnemyStateMachine/OutOfGround
@onready var idle: IdleStateEnemy = $EnemyStateMachine/Idle
@onready var go_to_ground: GoToGroundStateEnemy = $EnemyStateMachine/GoToGround

var is_ground : bool = true
var is_out_of_ground : bool = false
var is_idle : bool = false
var is_go_to_ground : bool = false
func _on_limit_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		if is_out_of_ground || is_idle:
			state_machine.switch_state(go_to_ground)

func _ready() -> void:
	state_machine.switch_state(ground)

func _on_body_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		print("collision player")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "out_of_ground":
		state_machine.switch_state(idle)
	if anim_name == "go_to_ground":
		state_machine.switch_state(ground)

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if is_ground:
		state_machine.switch_state(out_of_ground)
	if is_idle:
		#attack
		pass

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if is_out_of_ground || is_idle:
		state_machine.switch_state(go_to_ground)
