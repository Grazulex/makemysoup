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
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var ray_cast_2d_2: RayCast2D = $RayCast2D2
@onready var label: Label = $Label

var is_moving = false
var is_punch = false
var is_whacking = false

var direction : float = 0.0
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	attacked.connect(on_attacked)
	animation_tree.active = true
	stop_moving()
	
func on_attacked(hit_damage: int) -> void:
		healt -= hit_damage
		print("ennemy say : aie " + str(hit_damage) + ". healt in now "+str(healt))	
		is_whacking = true

func _process(delta: float) -> void:
	update_animation_parameters()

func _physics_process(delta: float) -> void:
	label.text = str(timer.time_left)
	if is_moving:
		direction = Global.target_position.x
		velocity = position.direction_to(Vector2(Global.target_position.x,0)) * speed
		if (ray_cast_2d.is_colliding() && ray_cast_2d.get_collider().get_parent() == player) || (ray_cast_2d_2.is_colliding() &&  ray_cast_2d_2.get_collider().get_parent() == player):
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

	if direction!= 0.0:
		animation_tree["parameters/Idle/blend_position"] = direction
		animation_tree["parameters/Punch/blend_position"] = direction
		animation_tree["parameters/Whacked/blend_position"] = direction
		animation_tree["parameters/Walk/blend_position"] = direction


func _on_timer_timeout() -> void:
	if !is_moving:
		start_moving()
		is_punch = false
		timer.stop()
	else:
		stop_moving()

func start_moving() -> void:
	ray_cast_2d.enabled = true
	ray_cast_2d_2.enabled = true
	is_moving = true
	
func stop_moving() -> void:
	ray_cast_2d.enabled = false
	ray_cast_2d_2.enabled = false
	is_moving = false
	reset_time()

func reset_time() -> void:
	timer.wait_time =  rng.randf_range(3, 10)
	timer.start()

func _on_hurt_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		var player = area.get_parent()
		player.attacked.emit(damage)
