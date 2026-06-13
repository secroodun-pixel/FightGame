class_name MovementState
extends State

#@export var base_move_speed : float = 4.0
@export var blend_position_parameter : String


var move_speed : float

func update(delta : float):
	super.update(delta)
	
	# set movement direction
	var move_dir : int = input_buffer.move_direction()
	
	# movement
	fighter.move_velocity.x = move_dir * fighter.character.base_move_speed #move_speed

	# blend animation
	if blend_position_parameter.length() == 0:
		return
	var blend_pos : float = move_dir * fighter.forward_direction
	animation.set_blend_position(blend_position_parameter, blend_pos)
	
func exit():
	super.exit()
	fighter.move_velocity.x = 0
