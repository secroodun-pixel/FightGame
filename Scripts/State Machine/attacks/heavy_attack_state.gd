class_name HeavyAttackState
extends AttackingState

var base_speed : float = 1
var charge_speed : float = 0.3
var max_charge_time : float = 4

var is_charging : bool

func _stamina_cost () -> float:
	return stamina_data.heavy_attack_cost

func enter():
	super.enter()
	is_charging = true
	var attack_length = animation.anim_player.get_animation("Fighter/HeavyAttack").length
	duration = attack_length
	print(attack_length)
	print(duration)
	print("vvv")
func update(delta : float):
	super.update(delta)
	
	# charge the attack
	if input_buffer.is_pressed('heavy_attack') and is_charging:
	
		# scale anim speed and increase attack duration to match
		animation.anim_tree.set("parameters/HeavyAttack/TimeScale/scale", charge_speed)
		print(animation.anim_tree.get("parameters/HeavyAttack/TimeScale/scale"))
		duration += delta 
		hit_detect_end_time += delta
		# check that we have no exceeded max charge, finish attack if so
		if duration >= max_charge_time:
			is_charging = false
		
	# finish the attack if not charging
	else:
		animation.anim_tree.set("parameters/HeavyAttack/TimeScale/scale", base_speed)
		is_charging = false
