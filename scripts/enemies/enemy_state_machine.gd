extends Node
class_name EnemyStateMachine

@export var current_state : StateEnemy
@export var enemy : CharacterBody2D

var states : Array[StateEnemy]

func _ready() -> void:
	for child in get_children():
		if child is StateEnemy:
			states.append(child)
			
			child.enemy = enemy


func _process(delta: float) -> void:
	pass

func switch_state(new_state : StateEnemy) -> void:
	if (current_state != new_state):
		if(current_state != null):
			current_state.on_exit()
		current_state = new_state
		print(new_state.name)
		current_state.on_enter()
