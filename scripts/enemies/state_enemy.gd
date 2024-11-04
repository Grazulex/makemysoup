extends Node
class_name  StateEnemy

@export var _next_state : StateEnemy

var enemy : CharacterBody2D
var next_state : StateEnemy

func on_enter() -> void:
	pass
	
func on_exit() -> void:
	pass
	
func on_animation_finised(anim_name: StringName) -> void:
	pass	

func on_visible_on_screen() -> void:
	pass
	
func on_leave_screen() -> void:
	pass	
