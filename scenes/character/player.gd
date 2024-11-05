extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer

@onready var state_machine: PlayerStateMachine = $PlayerStateMachine

@onready var idle: IdleState = $PlayerStateMachine/Idle
@onready var walk: WalkState = $PlayerStateMachine/Walk
@onready var jump: JumpState = $PlayerStateMachine/Jump
@onready var squat: SquatState = $PlayerStateMachine/Squat
@onready var attack: AttackState = $PlayerStateMachine/Attack
@onready var falling: FallingState = $PlayerStateMachine/Falling

@export var speed : float = 650.0

var is_idle : bool = true
var is_walking : bool = false
var is_jumping : bool = false
var is_squat : bool = false
var is_attack : bool = false
var is_falling : bool = false

var direction : float

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		state_machine.switch_state(jump)
		
	if Input.is_action_just_pressed("squat") and is_on_floor():
		state_machine.switch_state(squat)
		
	if Input.is_action_just_pressed("attack") and is_on_floor():
		state_machine.switch_state(attack)	

	direction = Input.get_axis("left", "right")

	if !is_jumping && !is_squat && !is_attack:
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
			sprite_2d.flip_h = true
			sprite_2d.offset.x = 150
		elif direction > 0:
			sprite_2d.flip_h = false
			sprite_2d.offset.x = 0


	move_and_slide()
