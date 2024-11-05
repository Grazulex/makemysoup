extends Enemy

@export var player : CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer

@onready var state_machine: EnemyStateMachine = $EnemyStateMachine

@onready var ground: GroundStateEnemy = $EnemyStateMachine/Ground
@onready var attack: AttackStateEnemy = $EnemyStateMachine/Attack
@onready var land: LandStateEnemy = $EnemyStateMachine/Land
@onready var torpedo: TorpedoStateEnemy = $EnemyStateMachine/Torpedo

@onready var timer: Timer = $Timer

var is_ground : bool = true
var is_out_of_ground : bool = false
var is_idle : bool = false
var is_go_to_ground : bool = false
var is_attack : bool = false
var is_torpedo : bool = false
var is_landing : bool = false

var rng = RandomNumberGenerator.new()
var speed : float = 600.0
var target_position : Vector2 = Vector2.ZERO
var original_position : Vector2 = Vector2.ZERO

func _ready() -> void:
	state_machine.switch_state(ground)
	original_position = position
	
func _process(_delta: float) -> void:
	if is_torpedo:
		velocity = position.direction_to(target_position) * speed
		move_and_slide()
	if !is_torpedo:
		if player.global_position < global_position:
			sprite_2d.flip_h = false
		else:
			sprite_2d.flip_h = true
	if is_attack:
		if player.global_position < global_position:
			target_position = Vector2(player.position.x - 500, original_position.y + rng.randf_range(-600, 200))
		else :
			target_position = Vector2(player.position.x + 500, original_position.y + rng.randf_range(-600, 200))
	
func _on_body_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		print("collision player")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	state_machine.current_state.on_animation_finised(anim_name)

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	timer.wait_time  = rng.randf_range(3, 10)
	timer.start()
	state_machine.current_state.on_visible_on_screen()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	timer.stop()
	state_machine.current_state.on_leave_screen()

func _on_timer_timeout() -> void:
	if is_idle:
		timer.wait_time  = rng.randf_range(1, 3)
		state_machine.switch_state(attack)
		timer.start()
	if is_torpedo:
		timer.wait_time  = rng.randf_range(3, 10)
		state_machine.switch_state(land)
		timer.start()
		
