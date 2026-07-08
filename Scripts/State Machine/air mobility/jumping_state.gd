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
	print(fighter.jump_height)
	
func update(delta : float):
	# get local time because not using super
	var time : float = Time.get_unix_time_from_system()
	local_time = time - enter_time
	
	if local_time >= 0.05:
		fighter.just_entered_jump = false
	
	# gravity
	fighter.move_velocity.y -= fighter.jump_gravity * delta
	
	# fall state if we are at the peak of the jump
	if (not fighter.is_on_floor() 
		and fighter.move_velocity.y <= 0
		and not fighter.just_entered_jump):
		state_machine.change_state("Falling")	
		
	# air dash	
	if input_buffer.is_pressed("dash"):
		state_machine.change_state("AirDashing")
		return
	
	# air light attack
	if input_buffer.is_pressed("light_attack"):
		state_machine.change_state("AirLightAttack")
		return
		
	# air heavy attack
	if input_buffer.is_pressed("heavy_attack"):
		state_machine.change_state("AirHeavyAttack")
		return

	# early exit with block
	if input_buffer.is_pressed("block") and fighter.has_air_block:
		state_machine.change_state("AirBlocking")
		return
		
	# hover state, if allowed
	if (input_buffer.just_pressed("jump") 
	and fighter.has_air_hover
	and fighter.can_hover):
		state_machine.change_state("Hovering")
		return
	
	# air influence, if allowed
	if fighter.has_air_influence and not fighter.has_used_air_influence:
		if input_buffer.just_pressed("move_left"):
			fighter.move_velocity.x -= fighter.air_influence_amount
		if input_buffer.just_pressed("move_right"):
			fighter.move_velocity.x += fighter.air_influence_amount
	
func exit():
	# check if we landed
	if fighter.is_on_floor():
		fighter.move_velocity.y = 0
		animation.set_animation("JumpLand")
