class_name DefeatedState
extends State

func enter():
	super.enter()
	animation.set_animation("Defeated")
	
func update(_delta : float):
	if input_buffer.is_pressed("jump"):
		state_machine.change_state("Upgrading")
		fighter.opponent.state_machine.change_state("Upgrading")
		GlobalEvents.ReadyToSelectUpgrades.emit(fighter)
