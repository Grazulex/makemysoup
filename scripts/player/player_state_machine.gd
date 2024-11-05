extends Node
class_name PlayerStateMachine

@export var current_state : State
@export var player : CharacterBody2D

@onready var label_state_debug: Label = $"../LabelStateDebug"

var states : Array[State]

func _ready() -> void:
	for child in get_children():
		if child is State:
			states.append(child)
			
			child.player = player


func _process(_delta: float) -> void:
	label_state_debug.text = "State: " + current_state.name
	pass

func switch_state(new_state : State) -> void:
	if (current_state != new_state):
		if(current_state != null):
			current_state.on_exit()
		current_state = new_state
		current_state.on_enter()
