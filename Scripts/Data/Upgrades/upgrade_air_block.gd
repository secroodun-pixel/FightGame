class_name  UpgradeAirBlock
extends UpgradeData

func apply_upgrade(fighter : Fighter):
	print("upgrade air block")
	fighter.has_air_block = true
