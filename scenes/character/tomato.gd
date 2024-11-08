extends CharacterBody2D

signal attacked(damage : int)

@export var player : CharacterBody2D
@export var speed : float = 300.0
@export var healt : int = 300
@export var damage : int = 100

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var timer: Timer = $Timer

@onready var detection_ray_cast_right: RayCast2D = $Detection_Player/Detection_RayCast_Right
@onready var detection_ray_cast_left: RayCast2D = $Detection_Player/Detection_RayCast_Left

@onready var label: Label = $Label

var is_moving = false
var is_punch = false
var is_whacking = false
var is_die = false

var direction : float = 0.0
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	attacked.connect(on_attacked)
	animation_tree.active = true
	stop_moving()
	
func on_attacked(hit_damage: int) -> void:
		healt -= hit_damage
		if healt <= 0:
			is_die = true
		else:
			is_whacking = true
		

func _process(delta: float) -> void:
	update_animation_parameters()

func _physics_process(delta: float) -> void:
	label.text = str(timer.time_left)
	if is_moving:
		direction = Global.target_position.x
		velocity = position.direction_to(Vector2(Global.target_position.x,0)) * speed
		if (detection_ray_cast_right.is_colliding() && detection_ray_cast_right.get_collider().get_parent() == player) || (detection_ray_cast_left.is_colliding() &&  detection_ray_cast_left.get_collider().get_parent() == player):
			stop_moving()
			is_punch = true
		elif abs(Global.target_position.x - position.x) < 300:
			stop_moving()
	else:
		Global.target_position = player.position
		velocity = Vector2.ZERO
	move_and_slide()

func update_animation_parameters() -> void:
	if (velocity == Vector2.ZERO):
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true

	if is_punch:
		animation_tree["parameters/conditions/punch"] = true
		is_punch = false
		reset_time()
	else:
		animation_tree["parameters/conditions/punch"] = false
		
	if is_whacking:
		animation_tree["parameters/conditions/is_whacking"] = true
		is_whacking = false
	else:
		animation_tree["parameters/conditions/is_whacking"] = false

	if is_die:
		animation_tree["parameters/conditions/is_die"] = true
		await get_tree().create_timer(1).timeout
		queue_free()
		

	if direction!= 0.0:
		animation_tree["parameters/Idle/blend_position"] = direction
		animation_tree["parameters/Punch/blend_position"] = direction
		animation_tree["parameters/Whacked/blend_position"] = direction
		animation_tree["parameters/Walk/blend_position"] = direction
		animation_tree["parameters/Die/blend_position"] = direction


func _on_timer_timeout() -> void:
	if !is_moving && !is_whacking:
		start_moving()
		is_punch = false
		timer.stop()
	else:
		stop_moving()

func start_moving() -> void:
	detection_ray_cast_left.enabled = true
	detection_ray_cast_right.enabled = true
	is_moving = true
	
func stop_moving() -> void:
	detection_ray_cast_right.enabled = false
	detection_ray_cast_left.enabled = false
	is_moving = false
	reset_time()

func reset_time() -> void:
	timer.wait_time =  rng.randf_range(3, 10)
	timer.start()

func _on_hurt_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		var player = area.get_parent()
		player.attacked.emit(damage)
