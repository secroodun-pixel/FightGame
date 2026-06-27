class_name StandingState
extends MovementState

var buffer_window : float = 8.0

func enter():
	super.enter()
	animation.set_animation("Standing")
	
	# reset air variables because we must have landed
	fighter.can_hover = true
	
func update(delta : float):
	super.update(delta)
	
	if input_buffer.was_pressed("light_attack", buffer_window):
		input_buffer.is_being_held("light_attack")
		state_machine.change_state("LightAttack")
		return
		
	if input_buffer.was_pressed("heavy_attack", buffer_window):
		input_buffer.is_being_held("heavy_attack")
		state_machine.change_state("HeavyAttack")
		return
	
	if input_buffer.is_pressed("jump"):
		state_machine.change_state("Jumping")
		return
	
	if input_buffer.is_pressed("block"):
		state_machine.change_state("Blocking")
		
	if input_buffer.is_pressed("dash"):
		input_buffer.is_being_held("dash")
		state_machine.change_state("Dashing")
		return
