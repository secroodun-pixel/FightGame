class_name FallingState
extends MovementState

@export var jump_force : float = 5.0
@export var air_influence : float = .7

func enter():
	animation.set_animation("JumpIdle")

func update(delta : float):
	# gravity
	fighter.move_velocity.y -= fighter.jump_gravity * delta
	
	# air dash
	if input_buffer.is_pressed("dash"):
		state_machine.change_state("AirDashing")
		return
		
	# air light attack
	if input_buffer.is_pressed("light_attack"):
		state_machine.change_state("AirLightAttack")
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
		
	# early exit with block, if allowed
	if input_buffer.is_pressed("block") and fighter.has_air_block:
		state_machine.change_state("AirBlocking")
		return
	
	# land if we've landed
	if fighter.is_on_floor():
		state_machine.change_state("Standing")
		return
