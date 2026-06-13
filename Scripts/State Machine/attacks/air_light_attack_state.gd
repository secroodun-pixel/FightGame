class_name AirLightAttackState
extends AttackingState

@export var vertical_divekick : float = -8
@export var horizontal_divekick : float = 5


func enter():
	# zero out velocity
	fighter.move_velocity = Vector3.ZERO
	super.enter()
	duration = indefinite_duration
	
func update(delta : float):
	super.update(delta)

	fighter.move_velocity.y = vertical_divekick
	fighter.move_velocity.x = horizontal_divekick * fighter.forward_direction

	if fighter.is_on_floor():
		state_machine.change_state("Standing")
		return

func exit():
	fighter.move_velocity.y = 0
	animation.set_animation("JumpLand")
