class_name BlockingState
extends State


func enter():
	fighter.is_blocking = true
	animation.set_animation("Standing")
	print("blocking!")
		
func update(_delta : float):
	if input_buffer.just_released("block"):
		print("not blocking")
		state_machine.change_state("Standing")

func exit():
	fighter.is_blocking = false
