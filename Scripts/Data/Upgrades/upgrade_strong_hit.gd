class_name  UpgradeStrongHit
extends UpgradeData

func apply_upgrade(fighter : Fighter):
	print("upgrade first hit")
	fighter.strong_first_hit = true
