class_name UpgradeData
extends Resource

# base class that invividual upgrades extend from

@export var upgrade_name : String
@export var upgrade_description : String

enum Upgrade_Group{
	Base_Stats,
	Light_Attack,
	Heavy_Attack,
	Air_Movement
}

func apply_upgrade(fighter : Fighter):
	pass
