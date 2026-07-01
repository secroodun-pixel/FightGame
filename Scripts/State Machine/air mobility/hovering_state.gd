class_name HoveringState
extends MovementState

var max_hover_time : float = 2.0
var hover_gravity : float = 0.04
var hover_speed : float = .25

func enter():
	super.enter()
	fighter.move_velocity.x = 0
	fighter.move_velocity.y = 0
	animation.set_animation("Hover")
	
	# mark that we cannot hover again yet
	fighter.can_hover = false

func update(delta : float):
	super.update(delta)

	# allow movement during hover
	var move_dir : int = input_buffer.move_direction()
	fighter.move_velocity.x = move_dir * fighter.move_speed * hover_speed
	# gravity
	fighter.move_velocity.y -= hover_gravity * delta
	
	# start falling after max duration reached
	if local_time >= max_hover_time:
		state_machine.change_state("Falling")
		return
	
	# early fall exit
	if input_buffer.is_pressed("crouch"):
		state_machine.change_state("Falling")
		return
