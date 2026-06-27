class_name  UpgradeHealth
extends UpgradeData

var increase_amount : int = 1

func apply_upgrade(fighter : Fighter):
	print("upgrade health")
	fighter.max_health += increase_amount
