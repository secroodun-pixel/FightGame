class_name UpgradeHover
extends UpgradeData

func apply_upgrade(fighter : Fighter):
	print("upgrade hover!")
	fighter.has_air_hover = true
