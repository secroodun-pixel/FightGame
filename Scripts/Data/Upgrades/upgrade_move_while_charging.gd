class_name UpgradeMoveWhileCharging
extends UpgradeData

func apply_upgrade(fighter : Fighter):
	print("upgrade move while charging")
	fighter.can_move_while_charging = true
