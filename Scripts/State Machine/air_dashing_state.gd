class_name AirDashingState
extends MovementState

@export var distance : float
@export var duration : float
var cooldown_end_time : float
var move_dir : int

func can_enter() -> bool:
	# prevent air dashing if we can't
	if not fighter.can_air_dash:
		return false
		
	# allow air dashing if none of the above
	return true

func enter():
	super.enter()
	
	# zero out existing movement, dash movement happens during update
	fighter.move_velocity = Vector3.ZERO
	
	# invulnerability
	move_dir = input_buffer.move_direction()
	animation.set_animation("Dash")

func update(delta : float):
	super.update(delta)

	# go back to standing when finished
	if local_time >= duration and not fighter.is_on_floor():
		state_machine.change_state("Falling")
		return
	
	# dash forward
	var speed : float = distance / duration

	if move_dir != 0:
		fighter.move_velocity.x = speed * move_dir
	elif move_dir == 0:
		fighter.move_velocity.x = 0
		
	# end dash if on floor
	if fighter.is_on_floor():
		state_machine.change_state("Standing")
		return
		
	# fall if dash ended
	if not fighter.is_on_floor() and local_time >= duration:
		animation.set_animation("JumpIdle")
		state_machine.change_state("Falling")
		return
		
func exit():
	super.exit()
	fighter.can_air_dash = false
	fighter.move_velocity = Vector3.ZERO
