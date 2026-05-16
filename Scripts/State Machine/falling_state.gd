class_name FallingState
extends MovementState


@export var jump_force : float = 5.0
@export var air_influence : float = .7

var jump_direction : float = 0.0


func enter():
	move_speed = 4.0
	animation.set_animation("JumpIdle")
	# lock jump direction
	jump_direction = input_buffer.move_direction()

func update(delta : float):
	# gravity
	fighter.move_velocity.y -= gravity * delta

	# direction of air influence
	var input_direction : float = input_buffer.move_direction()
	
	# blend direction into jump trajectory
	var true_direction = lerp(jump_direction, input_direction, air_influence)
	var target_x = true_direction * move_speed
	fighter.move_velocity.x = lerp(
		fighter.move_velocity.x,
		target_x,
		8.0 * delta
	)
	
	fighter.move_velocity.x = true_direction * move_speed

	# air dash
	if input_buffer.is_pressed("dash"):
		state_machine.change_state("AirDashing")
	
	# land if we've landed
	if fighter.is_on_floor():
		state_machine.change_state("Standing")
		
func exit():
	fighter.move_velocity.y = 0
	animation.set_animation("JumpLand")
