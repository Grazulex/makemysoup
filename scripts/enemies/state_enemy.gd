extends Node
class_name  StateEnemy

var enemy : CharacterBody2D
var start_state : StateEnemy
var next_state : StateEnemy
var rng = RandomNumberGenerator.new()

func on_enter() -> void:
	pass
	
func on_exit() -> void:
	pass
	
func process(_delta: float, _player : CharacterBody2D) -> void:
	pass

func on_body_area_entered(_area: Area2D) -> void:
	pass
	
func on_animation_finised(_anime_name: StringName) -> void:
	pass	

func on_visible_on_screen() -> void:
	pass
	
func on_leave_screen() -> void:
	pass
