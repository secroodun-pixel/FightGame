class_name  UpgradeJumpSpeed
extends UpgradeData

var increase_amount : float= 1.5
var jump_height_increase_amount : float = 4.5

#var horizontal_force : float = 7.0
#var jump_height : float = 1.0
#var jump_time_to_peak : float = 0.3
#var jump_time_to_descent : float = 0.2

func apply_upgrade(fighter : Fighter):
	fighter.jump_time_to_peak *= increase_amount
	fighter.jump_time_to_descent *= increase_amount
	fighter.jump_height *= jump_height_increase_amount
	print("upgrade jump")
	pass
