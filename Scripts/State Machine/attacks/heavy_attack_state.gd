class_name HeavyAttackState
extends AttackingState

var base_speed : float = 1
var charge_speed : float = 0.3

var charge_time : float = 0.0


func _stamina_cost () -> float:
	return stamina_data.heavy_attack_cost

func enter():
	super.enter()
	max_charge_time  = 2.5
	is_charging = true
	
	# get durations of separate attack animations
	windup_length = animation.anim_player.get_animation("HeavyAttackWindup").length
	charge_length = animation.anim_player.get_animation("HeavyAttackCharge").length
	active_length = animation.anim_player.get_animation("HeavyAttackActive").length
	recovery_length = animation.anim_player.get_animation("HeavyAttackWindup").length
	
	duration = (attack_length + 
				charge_length + 
				active_length + 
				recovery_length -
				0.5)
	attack_end_length = active_length + recovery_length
	
	early_out_time = windup_length + active_length + recovery_length
	charge_time = 0.0


func update(delta : float):
	super.update(delta)

	# charge the attack
	if is_charging:
		if input_buffer.is_pressed('heavy_attack'):
			# scale anim speed and increase attack duration to match
			animation.anim_tree.set("parameters/HeavyAttackCharge/TimeScale/scale", charge_speed)
			charge_time += delta 
			duration += delta 
			early_out_time += delta
			hit_detect_end_time += delta
			
			# check that we have no exceeded max charge, finish attack if so
			if charge_time >= max_charge_time:
				early_out_time = charge_time + attack_end_length
				finish_charging()
		# finish the attack if not charging
		elif local_time >= min_charge_time:
			finish_charging()
	# finish the attack if not charging
	#elif local_time >= min_charge_time:
		#finish_charging()

func finish_charging():
	is_charging = false
	animation.anim_tree.set("parameters/HeavyAttackCharge/TimeScale/Scale", base_speed)
	animation.set_animation("HeavyAttackActive")
