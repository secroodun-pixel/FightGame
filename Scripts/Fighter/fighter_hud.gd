extends Panel

@onready var fighter : Fighter = $"../.."

@onready var health_block : Panel = $HBoxContainer/HealthBlock
@onready var health_container : HBoxContainer = $HBoxContainer

var max_health : int = 1
var current_health : int = 1

@onready var player_0_pos : Control = $"../Player0Pos_Health"
@onready var player_1_pos : Control = $"../Player1Pos_Health"

# active upgrade info
@onready var upgrade_icon : PackedScene = load("res://Scenes/Icons/Upgrade_Icon.tscn")
@onready var upgrade_container : HBoxContainer = $UpgradeBar

func _ready() -> void:
	max_health = fighter.max_health
	
	# position health bars
	if fighter.player_id == 0:
		position = player_0_pos.position
	elif fighter.player_id == 1:
		position = player_1_pos.position
	
	for i in range(max_health - 1):
		var dup_container = health_block.duplicate()
		health_container.add_child(dup_container)
		
	# events
	# connect fighter damage event to the healthbar	
	GlobalEvents.FighterDamaged.connect(_update_health_bar)
	GlobalEvents.GoToNextRound.connect(_reset_health_bar)
	
func _update_health_bar (damaged_fighter : Fighter):
	# check that it is the other fighter
	if damaged_fighter != fighter:
		return
			
	# get current health
	var current_health_display = fighter.current_health

	# go through each container
	for i in range(health_container.get_child_count()):
		var block = health_container.get_child(i)
		block.visible = i < current_health_display

func _reset_health_bar(fighter_to_reset : Fighter):
	if fighter_to_reset != fighter:
		return
		
	# get new max health and count how many bars we have now
	var new_max_health = fighter.max_health
	var current_block_count = health_container.get_child_count()
	var desired_block_count = new_max_health

	# check if we need to make more blocks
	if (desired_block_count - current_block_count) > 0:
		var new_blocks = desired_block_count - current_block_count
		
		# make new blocks
		for i in range(new_blocks):
			var dup_container = health_block.duplicate()
			health_container.add_child(dup_container)
	
	# update visibility of health blocks
	for i in range(health_container.get_child_count()):
		var visible_health_block = health_container.get_child(i)
		visible_health_block.visible = true
		
	_update_upgrades_display(fighter)

func _update_upgrades_display(current_fighter : Fighter):
	# get list of upgrades
	var list_of_upgrades : Array = current_fighter.active_upgrades
	
	for upgrade in range(list_of_upgrades.size()):
		if upgrade != (list_of_upgrades.size() - 1):
			pass
		else:
			var icon = upgrade_icon.instantiate()
			var upgrade_info = list_of_upgrades[upgrade]
			icon.x_index = upgrade_info.icon_x_index
			icon.y_index = upgrade_info.icon_y_index
			upgrade_container.add_child(icon)
		
	
