class_name JumpingState

extends MovementState

@export var jump_force : float = 5.0
@export var air_influence : float = .7

var jump_direction : float = 0.0


func enter():
	move_speed = 4.0
	
	# lock jump direction
	jump_direction = input_buffer.move_direction()
	
	fighter.move_velocity.y = jump_force
	animation.set_animation("JumpStart")

func update(delta : float):
	# gravity
	fighter.move_velocity.y -= gravity * delta
	
	# direction of air influence
	var input_direction : float = input_buffer.move_direction()
	
	# blend direction into jump trajectory
	var true_direction = lerp(jump_direction, input_direction, air_influence)
	fighter.move_velocity.x = true_direction * move_speed
	
	# fall state if we are at the peak of the jump
	if not fighter.is_on_floor() and fighter.velocity.y < 0:
		state_machine.change_state("Falling")	
	
	# standing state if landed
	if fighter.is_on_floor():
		state_machine.change_state("Standing")
		
	if input_buffer.is_pressed("dash"):
		state_machine.change_state("AirDashing")
		return
		
func exit():
	# check if we landed
	if fighter.is_on_floor():
		fighter.move_velocity.y = 0
		animation.set_animation("JumpLand")
