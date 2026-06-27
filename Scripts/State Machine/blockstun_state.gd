class_name BlockstunState
extends State

@export var duration : float = 0.45
@export var knockback_amount : float = 2.0
@export var knockback_time : float = 0.07

@export var animation_name : String

func enter():
	super.enter()
	animation.set_animation(animation_name)
	
func update(delta : float):
	super.update(delta)
	
	if local_time < knockback_time:
		# apply knockback
		fighter.move_velocity.x = (move_toward(
				knockback_amount * 2,
				knockback_amount,
				duration * delta
				) 
				* -fighter.forward_direction
			)
	else:
		fighter.move_velocity.x = 0
	
	# exit blockstun
	if local_time >= duration:
		fighter.state_machine.change_state("Standing")
