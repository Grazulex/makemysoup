extends CharacterBody2D
class_name  Player

signal attacked(damage : int)

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var hit: Area2D = $Hit
@onready var hurt: Area2D = $Hurt

@onready var state_machine: PlayerStateMachine = $PlayerStateMachine

@onready var idle: IdleState = $PlayerStateMachine/Idle
@onready var walk: WalkState = $PlayerStateMachine/Walk
@onready var jump: JumpState = $PlayerStateMachine/Jump
@onready var squat: SquatState = $PlayerStateMachine/Squat
@onready var attack: AttackState = $PlayerStateMachine/Attack
@onready var falling: FallingState = $PlayerStateMachine/Falling
@onready var damaged: DamagedState = $PlayerStateMachine/Damaged

@export var speed : float = 650.0
@export var healt : int = 1000
@export var damage : int = 100

var is_idle : bool = true
var is_walking : bool = false
var is_jumping : bool = false
var is_squat : bool = false
var is_attack : bool = false
var is_falling : bool = false
var is_damaged : bool = false

var direction : float

func _ready() -> void:
	attacked.connect(on_attacked)

func on_attacked(hit_damage: int) -> void:
	healt -= hit_damage
	print("player say : aie " + str(hit_damage) + ". healt in now "+str(healt))
	state_machine.switch_state(damaged)
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "damaged":
		state_machine.switch_state(idle)
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		state_machine.switch_state(jump)
		
	if Input.is_action_just_pressed("squat") and is_on_floor():
		state_machine.switch_state(squat)
		
	if Input.is_action_just_pressed("attack") and is_on_floor():
		state_machine.switch_state(attack)
		
		var detect_areas = hurt.get_overlapping_areas()
		for detect_area in detect_areas:
			if detect_area.is_in_group("enemy"):
				var enemy = detect_area.get_parent()
				enemy.attacked.emit(damage)

	direction = Input.get_axis("left", "right")

	if !is_jumping && !is_squat && !is_attack && !is_damaged:
	#if state_machine.current_state.can_move:
		if direction:
			walk.set_direction(direction)
			state_machine.switch_state(walk)
		else:
			if is_on_floor():
				state_machine.switch_state(idle)
			else:
				state_machine.switch_state(falling)
			
		if direction < 0:
			sprite.flip_h = true
			sprite.offset.x = 150
		elif direction > 0:
			sprite.flip_h = false
			sprite.offset.x = 0


	move_and_slide()
