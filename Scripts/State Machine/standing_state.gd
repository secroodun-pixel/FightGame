class_name StandingState

extends MovementState

func enter():
	super.enter()
	
	move_speed = 5
	
	
	# reset anything that cares about having landed
	fighter.can_air_dash = true

func update(delta : float):
	super.update(delta)
	
	if input_buffer.is_pressed("light_attack"):
		state_machine.change_state("LightAttack")
		return
		
	if input_buffer.is_pressed("heavy_attack"):
		state_machine.change_state("HeavyAttack")
		return
	
	if input_buffer.is_pressed("jump"):
		state_machine.change_state("Jumping")
		return
		
	if input_buffer.is_pressed("dash"):
		state_machine.change_state("Dashing")
		return
