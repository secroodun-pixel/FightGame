extends Panel

@onready var fighter : Fighter = $"../.."

@onready var health_bar : ProgressBar = $HUDElements/HealthBar
@onready var health_text : Label = $HUDElements/HealthBar/HealthText

@onready var stamina_bar : ProgressBar = $HUDElements/StaminaBar

@onready var player_0_pos : Control = $"../Player0Pos"
@onready var player_1_pos : Control = $"../Player1Pos"

@onready var stamina_controller : StaminaController = $"../../StaminaController"

func _ready() -> void:
	# position health bars
	if fighter.player_id == 0:
		position = player_0_pos.position
	elif fighter.player_id == 1:
		position = player_1_pos.position
		scale.x = -1
	
	# health bar
	#health_bar.max_value = fighter.character.max_health
	_update_health_bar(fighter)
	
	# stamina
	# set stamina max value
	stamina_bar.max_value = stamina_controller.data.max_stamina
	
	# connect to stamina update signal
	stamina_controller.StaminaUpdated.connect(_update_stamina_bar)
	
	# events
	# connect fighter damage event to the healthbar	
	GlobalEvents.FighterDamaged.connect(_update_health_bar)
	
func _update_stamina_bar(stamina : float):
	stamina_bar.value = stamina

func _update_health_bar (damaged_fighter : Fighter):
	# check that it is the other fighter
	if damaged_fighter != fighter:
		return
	
	# update health visuals
	health_bar.value = fighter.current_health
	health_text.text = str(int(fighter.current_health))
