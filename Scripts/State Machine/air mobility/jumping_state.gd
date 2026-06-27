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
	fighter.move_velocity.y = fighter.jump_velocity
	fighter.move_velocity.x = fighter.horizontal_force * jump_direction
	animation.set_animation("JumpStart")
	
func update(delta : float):
	# get local time because not using super
	var time : float = Time.get_unix_time_from_system()
	local_time = time - enter_time
	
	if local_time >= 0.05:
		fighter.just_entered_jump = false
	
	# gravity
	fighter.move_velocity.y -= fighter.jump_gravity * delta
	
	#print(fighter.move_velocity.y, fighter.is_on_floor(), fighter.just_entered_jump, local_time)
	## fall state if we are at the peak of the jump
	if (not fighter.is_on_floor() 
		and fighter.move_velocity.y <= 0
		and not fighter.just_entered_jump):
		state_machine.change_state("Falling")	
	
	# standing state if landed
	#if fighter.is_on_floor() and (local_time >= fighter.jump_start_blocker):
		#state_machine.change_state("Standing")
		#return
		
	# dash	
	if input_buffer.is_pressed("dash"):
		state_machine.change_state("AirDashing")
		return
	
	# air light attack
	if input_buffer.is_pressed("light_attack"):
		state_machine.change_state("AirLightAttack")
		return

	# hover state, if allowed
	if (input_buffer.is_pressed("block") 
	and fighter.has_air_hover
	and fighter.can_hover):
		state_machine.change_state("Hovering")
		return
	
func exit():
	# check if we landed
	if fighter.is_on_floor():
		fighter.move_velocity.y = 0
		animation.set_animation("JumpLand")
