extends Panel

@onready var fighter : Fighter = $"../.."
@onready var game_manager : GameManager
@export var upgrade_data : UpgradeData 

@onready var player_0_pos : Control = $"../Player0UpgradePos"
@onready var player_1_pos : Control = $"../Player1UpgradePos"

@onready var upgrade_01 : Panel = $Upgrade1
@onready var label_01 : Label = $Upgrade1/Upgrade1_Text

@onready var upgrade_02 : Panel = $Upgrade2
@onready var label_02 : Label = $Upgrade2/Upgrade2_Text

@onready var upgrade_03 : Panel = $Upgrade3
@onready var label_03 : Label = $Upgrade3/Upgrade3_Text

func _ready() -> void:
	# position upgrade UIs
	if fighter.player_id == 0:
		position = player_0_pos.position
	elif fighter.player_id == 1:
		position = player_1_pos.position
		
	# global connections
	GlobalEvents.BeginSelectingUpgrades.connect(_show_upgrade_choices)
	GlobalEvents.GameStateChanged.connect(_upgrade_visibility)
		
func _physics_process(delta: float) -> void:
	if fighter.is_upgrading:
		pass
		
func _upgrade_visibility(game_mode : GameManager.GameState):
	# show this ui
	if game_mode == game_manager.GameState.UPGRADESELECT:
		visible = true
	else:
		visible = false
	
func _hide_upgrades(fighter : Fighter):
	if fighter.has_selected_upgrade and fighter.opponent.has_selected_upgrade:
		visible = false

func _show_upgrade_choices(option_1 : UpgradeData, 
							option_2 : UpgradeData, 
							option_3 : UpgradeData):
								
	# set variables for what to display
	var option_1_name = option_1.upgrade_name
	var option_1_description = option_1.upgrade_description
	
	var option_2_name = option_2.upgrade_name
	var option_2_description = option_2.upgrade_description
	
	var option_3_name = option_3.upgrade_name
	var option_3_description = option_3.upgrade_description
	
	# label textsd
	label_01.text = option_1_name + "\n" + option_1_description
	label_02.text = option_2_name + "\n" + option_2_description
	label_03.text = option_3_name + "\n" + option_3_description
