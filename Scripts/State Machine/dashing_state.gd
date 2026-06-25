class_name DashingState
extends State


@export var distance : float
@export var duration : float
@export var cooldown : float
var cooldown_end_time : float
var move_dir : int


func can_enter() -> bool:
	# prevent dashing if on cooldown
	if Time.get_unix_time_from_system() < cooldown_end_time:
		return false
		
	# allow dashing if none of the above
	return stamina_controller.current_stamina > stamina_data.dash_cost

func enter():
	super.enter()
	
	# zero out existing movement, dash movement happens during update
	fighter.move_velocity = Vector3.ZERO
	
	# invulnerability
	fighter.is_invulnerable = true
	
	# dash direction
	move_dir = input_buffer.move_direction()
	animation.set_animation("Dash")
	
	# take stamina
	stamina_controller.consume_stamina(stamina_data.dash_cost)

func update(delta : float):
	super.update(delta)
	
	# go back to standing when finished
	if local_time >= duration:
		state_machine.change_state("Standing")
		return
	
	# dash speed
	var speed : float = distance / duration
	if move_dir != 0:
		fighter.move_velocity.x = speed * move_dir
	elif move_dir == 0:
		fighter.move_velocity.x = speed * fighter.forward_direction 

func exit():
	super.exit()
	fighter.move_velocity = Vector3.ZERO

	# set when cooldown is over, turn off invulnerability
	cooldown_end_time = Time.get_unix_time_from_system() + cooldown
	fighter.is_invulnerable = false
	
		
