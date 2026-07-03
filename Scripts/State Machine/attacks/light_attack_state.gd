class_name LightAttackState
extends AttackingState

#func _stamina_cost () -> float:
	#return stamina_data.light_attack_cost
	#
func enter():
	fighter.move_velocity.x = 0.0
	
	super.enter()
	attack_length = animation.anim_player.get_animation("LightAttack").length
	duration = attack_length
	hit_detect_start_time = 0.97
	hit_detect_end_time = 1.34
	
