extends Node
class_name EnemyStateMachine

@onready var label_state_debug: Label = $"../LabelStateDebug"

@export var current_state : StateEnemy
@export var start_state : StateEnemy
@export var enemy : CharacterBody2D

var states : Array[StateEnemy]

func _ready() -> void:
	for child in get_children():
		if child is StateEnemy:
			states.append(child)
			
			child.enemy = enemy
			child.start_state = start_state


func _process(_delta: float) -> void:
	if current_state.next_state != null:
		if (current_state.next_state != current_state):
			switch_state(current_state.next_state)
			current_state.next_state = null
		
func switch_state(new_state : StateEnemy) -> void:
	if (current_state != new_state):
		if(current_state != null):
			current_state.on_exit()
		current_state = new_state
		label_state_debug.text = "State: " + current_state.name
		current_state.on_enter()
