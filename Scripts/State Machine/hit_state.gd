class_name HitState
extends State

@export var duration : float
@export var animation_name : String

func enter():
	super.enter()
	animation.set_animation(animation_name)
	
func update(delta : float):
	super.update(delta)
	
	if local_time >= duration:
		state_machine.change_state("Standing")
		return
