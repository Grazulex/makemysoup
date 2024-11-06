extends Enemy

signal attacked(damage : int)

@export var player : CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer

@onready var state_machine: EnemyStateMachine = $EnemyStateMachine

@onready var ground: GroundStateEnemy = $EnemyStateMachine/Ground
@onready var attack: AttackStateEnemy = $EnemyStateMachine/Attack
@onready var land: LandStateEnemy = $EnemyStateMachine/Land
@onready var torpedo: TorpedoStateEnemy = $EnemyStateMachine/Torpedo
@onready var damaged: DamagedStateEnemy = $EnemyStateMachine/Damaged

@onready var timer: Timer = $Timer

var is_ground : bool = true
var is_out_of_ground : bool = false
var is_idle : bool = false
var is_go_to_ground : bool = false
var is_attack : bool = false
var is_torpedo : bool = false
var is_landing : bool = false
var is_damaged : bool = false

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	attacked.connect(on_attacked)
	state_machine.switch_state(ground)
	
func on_attacked(hit_damage: int) -> void:
	if !is_damaged:
		healt -= hit_damage
		state_machine.switch_state(damaged)
		print("ennemy say : aie " + str(hit_damage) + ". healt in now "+str(healt))
		
func _process(delta: float) -> void:
	state_machine.current_state.process(delta, player)
	if !is_torpedo:
		if player.global_position < global_position:
			sprite_2d.flip_h = false
		else:
			sprite_2d.flip_h = true
	
func _on_body_area_entered(area: Area2D) -> void:
	state_machine.current_state.on_body_area_entered(area)

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
		
