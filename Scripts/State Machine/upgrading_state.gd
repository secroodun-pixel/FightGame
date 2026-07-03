class_name UpgradingState
extends State

var selected_upgrade

var upgrade_01
var upgrade_02
var upgrade_03

var upgrade_01_button : String = "move_left"
var upgrade_02_button : String = "dash"
var upgrade_03_button : String = "move_right"

func enter():
	fighter.can_control = false
	fighter.is_upgrading = true
	super.enter()
	
	# Connect globals
	GlobalEvents.BeginSelectingUpgrades.connect(_connect_upgrades_to_buttons)
	
func update(_delta : float):
	# make sure an upgrade has not been selected yet
	if not fighter.has_selected_upgrade:
		if input_buffer.is_pressed(upgrade_01_button):
			print(fighter.player_id, " pressed left")
			# set upgrading states
			fighter.has_selected_upgrade = true
			fighter.is_upgrading = false
			
			# set chosen upgrade and emit
			selected_upgrade = upgrade_01
			GlobalEvents.UpgradeSelected.emit(fighter, selected_upgrade)
		elif input_buffer.is_pressed(upgrade_02_button):
			print(fighter.player_id, " pressed dash")
			# set upgrading states
			fighter.has_selected_upgrade = true
			fighter.is_upgrading = false
			
			# set chosen upgrade and emit
			selected_upgrade = upgrade_02
			GlobalEvents.UpgradeSelected.emit(fighter, selected_upgrade)
		elif input_buffer.is_pressed(upgrade_03_button):
			print(fighter.player_id, " pressed right")
			# set upgrading states
			fighter.has_selected_upgrade = true
			fighter.is_upgrading = false
			
			# set chosen upgrade and emit
			selected_upgrade = upgrade_03
			GlobalEvents.UpgradeSelected.emit(fighter, selected_upgrade)

func _connect_upgrades_to_buttons(option_1, option_2, option_3):
	upgrade_01 = option_1
	upgrade_02 = option_2
	upgrade_03 = option_3
