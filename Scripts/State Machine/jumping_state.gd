class_name JumpingState
extends MovementState

#@export var air_influence : float = .7

var jump_direction : float = 0.0

func enter():
	# jump start process
	fighter.just_entered_jump = true
	
	# lock jump direction
	jump_direction = input_buffer.move_direction()
	
	# apply jump forces
	fighter.move_velocity.y = fighter.character.jump_velocity
	fighter.move_velocity.x = fighter.character.horizontal_force * jump_direction
	animation.set_animation("JumpStart")
	
func update(delta : float):
	# gravity
	fighter.move_velocity.y += fighter.get_custom_gravity() * delta
	
	## fall state if we are at the peak of the jump
	if not fighter.is_on_floor() and fighter.move_velocity.y > 0:
		state_machine.change_state("Falling")	
	
	# standing state if landed
	if fighter.is_on_floor() and (local_time >= fighter.jump_start_blocker):
		#state_machine.change_state("Standing")
		return
	# dash	
	if input_buffer.is_pressed("dash"):
		state_machine.change_state("AirDashing")
		return
	
	# air light attack
	if input_buffer.is_pressed("light_attack"):
		state_machine.change_state("AirLightAttack")
		return
		
func exit():
	# check if we landed
	if fighter.is_on_floor():
		fighter.move_velocity.y = 0
		animation.set_animation("JumpLand")
