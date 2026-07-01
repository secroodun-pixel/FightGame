class_name AirHeavyAttackState
extends AttackingState

func enter():
	# zero out velocity
	fighter.move_velocity = Vector3.ZERO
	super.enter()
	duration = indefinite_duration
	
func update(delta : float):
	super.update(delta)
	if fighter.is_on_floor():
		state_machine.change_state("Standing")
		return

func exit():
	fighter.move_velocity.y = 0
	animation.set_animation("JumpLand")
