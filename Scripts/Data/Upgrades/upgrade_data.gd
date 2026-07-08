class_name UpgradeData
extends Resource

# base class that invividual upgrades extend from

@export var upgrade_name : String
@export var upgrade_description : String

@export var icon_x_index : int
@export var icon_y_index : int

enum Upgrade_Group{
	Base_Stats,
	Light_Attack,
	Heavy_Attack,
	Air_Movement
}

func apply_upgrade(_fighter : Fighter):
	pass
