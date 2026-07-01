class_name BlockingState
extends State


func enter():
	fighter.is_blocking = true
	animation.set_animation("Block")
	print("blocking!")
		
func update(_delta : float):
	if input_buffer.just_released("block"):
		fighter.is_blocking = false
		state_machine.change_state("Standing")
		print("not blocking")

func exit():
	fighter.is_blocking = false
