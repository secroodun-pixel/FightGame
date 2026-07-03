class_name HoveringState
extends MovementState

var max_hover_time : float = 2.0
var hover_gravity : float = 0.04
var hover_speed : float = 0.75
var hover_speed_vertical : float = 0.5

func enter():
	super.enter()
	animation.set_animation("Hover")
	
	# mark that we cannot hover again yet
	fighter.can_hover = false

func update(delta : float):
	super.update(delta)
	
	# allow movement during hover
	var move_dir : int = input_buffer.move_direction()
	fighter.move_velocity.x = move_dir * fighter.move_speed * hover_speed
	
	# allow moving up/down in hover
	var vertical_dir : int = input_buffer.vertical_direction()
	fighter.move_velocity.y = vertical_dir * fighter.move_speed * hover_speed_vertical
	
	# start falling after max duration reached
	if local_time >= max_hover_time:
		state_machine.change_state("Falling")
		return
	
	# early fall exits by attacking
	if input_buffer.is_pressed("light_attack"):
		state_machine.change_state("AirLightAttack")
		return
	if input_buffer.is_pressed("heavy_attack"):
		state_machine.change_state("AirHeavyAttack")
		return
		
	# early exit with block
	if input_buffer.is_pressed("block") and fighter.has_air_block:
		state_machine.change_state("AirBlocking")
		return
