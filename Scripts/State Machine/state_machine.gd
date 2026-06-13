class_name StateMachine
extends Node

@export var starting_state: State

@export var fighter : Fighter
@export var input_buffer : InputBuffer

# animation
@export var animation : FighterAnimation

# stamina
@export var stamina_controller : StaminaController

# state variables
var states : Dictionary[String, State] = { }
var current_state : State

func _ready():
	# get states list
	for child in get_children():
		if child is not State:
			continue

		states[child.name] = child
		child.initialize(self)
			
	if starting_state:
		change_state(starting_state.name)
			
func change_state(state_name : String):
	
	if not states.has(state_name):
		printerr("Cannot change state to ", state_name, " as it doesn't exist")
		return
	
	if not states[state_name].can_enter():
		return
	
	if current_state:
		current_state.exit()
		
	current_state = states[state_name]
	print(current_state)
	current_state.enter()
	
func update(delta: float):
	if not current_state:
		return
		
	current_state.update(delta)

func is_current_state(state_name : String) -> bool:
	if not current_state:
		return false
	
	return current_state.name == state_name
