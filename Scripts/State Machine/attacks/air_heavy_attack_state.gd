class_name AirHeavyAttackState
extends AttackingState

func enter():
	super.enter()
	
func update(delta : float):
	super.update(delta)

	if fighter.is_on_floor():
		fighter.move_velocity.x = 0.0
		state_machine.change_state("Standing")
		return

func exit():
	super.exit()
