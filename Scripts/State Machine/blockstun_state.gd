class_name BlockstunState
extends State

@export var duration : float = 0.45
@export var knockback_amount : float = 2.0
@export var knockback_time : float = 0.07

@export var animation_name : String

#var pushblock_duration : float = 0.1
#var pushblock_amount : float = 1.0
#var has_used_pushblock : bool = false
#var pushblock_start : float

func enter():
	super.enter()
	animation.set_animation(animation_name)
	#has_used_pushblock = false
	
func update(delta : float):
	super.update(delta)
	
	# knockback
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
	
	## pushblock
	#if ((input_buffer.is_pressed("light_attack") or
		#input_buffer.is_pressed("heavy_attack")) and 
		#not has_used_pushblock):
			#has_used_pushblock = true
			#
			## store variables for start of pushblock
			#pushblock_start = local_time
			#
			#fighter.opponent.move_velocity.x += (move_toward(
				#pushblock_amount * 2,
				#pushblock_amount,
				#pushblock_duration * delta
				#) 
				#* fighter.forward_direction
		#)
	
	# exit blockstun
	if local_time >= duration:
		if input_buffer.is_pressed("block"):
			fighter.state_machine.change_state("Blocking")
		else:
			fighter.state_machine.change_state("Standing")
