class_name  UpgradeAirInfluence
extends UpgradeData

func apply_upgrade(fighter : Fighter):
	print("upgrade air influence")
	fighter.has_air_influence = true
