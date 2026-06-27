class_name UpgradeMoveSpeed
extends UpgradeData

var increase_amount : float = 1.5

func apply_upgrade(fighter : Fighter):
	print("upgrade speed")
	fighter.move_speed += increase_amount
