extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer

@export var speed : float = 650.0
@export var jum_velocity : float = -400.0

var is_jumping : bool = false
var is_squat : bool = false
var is_attack : bool = false
var is_falling : bool = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jum_velocity
		animation_player.play("jump")
		is_jumping = true
		
	if Input.is_action_just_pressed("squat") and is_on_floor():
		animation_player.play("squat")
		is_squat = true
		
	if Input.is_action_just_pressed("attack") and is_on_floor():
		animation_player.play("attack")
		is_attack = true	

	var direction := Input.get_axis("left", "right")
	if !is_jumping && !is_squat && !is_attack:
		if direction:
			velocity.x = direction * speed
			animation_player.play("walk")
		else:
			if is_on_floor():
				velocity.x = move_toward(velocity.x, 0, speed)
				animation_player.play("idle")
			else:
				velocity.x = 0.0
				animation_player.play("falling")
				is_falling = true
			
		if direction < 0:
			sprite_2d.flip_h = true
			sprite_2d.offset.x = 150
		elif direction > 0:
			sprite_2d.flip_h = false
			sprite_2d.offset.x = 0


	move_and_slide()

func stop_jumping() -> void:
	is_jumping = false

func stop_squating() -> void:
	is_squat = false
	
func stop_attacking() -> void:
	is_attack = false	

func stop_falling() -> void:
	is_falling = false	
	get_tree().quit()
