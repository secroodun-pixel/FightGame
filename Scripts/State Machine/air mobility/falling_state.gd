class_name FallingState
extends MovementState

@export var jump_force : float = 5.0
@export var air_influence : float = .7

var jump_direction : float = 0.0

func enter():
	animation.set_animation("JumpIdle")
	# lock jump direction
	jump_direction = input_buffer.move_direction()

func update(delta : float):
	# gravity
	fighter.move_velocity.y -= fighter.jump_gravity * delta
	
	# air dash
	if input_buffer.is_pressed("dash"):
		state_machine.change_state("AirDashing")
		return
		
	# air dash
	if input_buffer.is_pressed("light_attack"):
		state_machine.change_state("AirLightAttack")
		return
		
	# hover state, if allowed
	if (input_buffer.is_pressed("block") 
	and fighter.has_air_hover
	and fighter.can_hover):
		state_machine.change_state("Hovering")
		return
	
	# land if we've landed
	if fighter.is_on_floor():
		state_machine.change_state("Standing")
		return
		
func exit():
	fighter.move_velocity.y = 0
	animation.set_animation("JumpLand")
