class_name HitState
extends State

@export var duration : float
@export var animation_name : String

func enter():
	super.enter()
	fighter.can_control = false
	animation.set_animation(animation_name)
	HitstopManager.hit_stop_medium()
	
	
func update(delta : float):
	super.update(delta)
	
	if local_time >= duration:
		fighter.can_control = true
		state_machine.change_state("Standing")
		return
