class_name VictoriousState
extends State


func enter():
	super.enter()
	fighter.can_control = false
	animation.set_animation("HeavyAttackCharge")

func update(_delta : float):
	if input_buffer.is_pressed("jump"):
		state_machine.change_state("Upgrading")
		fighter.opponent.state_machine.change_state("Upgrading")
		
		#GlobalEvents.ReadyToSelectUpgrades.emit(fighter)
		GlobalEvents.ReadyToSelectUpgrades.emit(fighter)
