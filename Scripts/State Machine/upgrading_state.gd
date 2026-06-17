class_name UpgradingState
extends State

@onready var game_manager : GameManager = $GameManager

func enter():
	fighter.can_control = false
	super.enter()
	GlobalEvents.UpgradeSelected.connect(update)
	
func update(delta : float):
	if input_buffer.is_pressed("dash") and not fighter.has_selected_upgrade:
		fighter.has_selected_upgrade = true
		print(fighter.player_id, " upgrade pressed")
		GlobalEvents.UpgradeSelected.emit(fighter)
