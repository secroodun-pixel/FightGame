class_name LightAttackState
extends AttackingState



func _stamina_cost () -> float:
	return stamina_data.light_attack_cost
	
func enter():
	super.enter()
	var attack_length = animation.anim_player.get_animation("Fighter/LightAttack").length
	duration = attack_length
	
