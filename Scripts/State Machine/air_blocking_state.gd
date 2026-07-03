class_name AirBlockingState
extends MovementState

func enter():
	fighter.is_blocking = true
	animation.set_animation("Block")
		
func update(delta : float):
	super.update(delta)
	
	apply_jump_gravity(delta)
	
	# out of block state
	if input_buffer.just_released("block"):
		fighter.is_blocking = false
		
		state_machine.change_state("Falling")

func exit():
	fighter.is_blocking = false
