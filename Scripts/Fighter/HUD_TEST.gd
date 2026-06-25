extends Panel

@onready var fighter : Fighter = $"../.."

@onready var health_block : Panel = $HBoxContainer/HealthBlock
@onready var health_container : HBoxContainer = $HBoxContainer

var max_health : int = 1
var current_health : int = 1

@onready var player_0_pos : Control = $"../Player0Pos"
@onready var player_1_pos : Control = $"../Player1Pos"

func _ready() -> void:
	# position health bars
	if fighter.player_id == 0:
		position = player_0_pos.position
	elif fighter.player_id == 1:
		position = player_1_pos.position
	
	for i in range(max_health - 1):
		var duplicate = health_block.duplicate()
		health_container.add_child(duplicate)
		
	# events
	# connect fighter damage event to the healthbar	
	GlobalEvents.FighterDamaged.connect(_update_health_bar)
	GlobalEvents.GoToNextRound.connect(_reset_health_bar)
	
func _update_health_bar (damaged_fighter : Fighter):
	# check that it is the other fighter
	if damaged_fighter != fighter:
		return
			
	# get current health
	var current_health = fighter.current_health

	# go through each container
	for i in range(health_container.get_child_count()):
		# update visibility of health blocks
		var health_block = health_container.get_child(i)
		
		if (i < current_health):
			health_block.visible = true
		elif current_health == 0:
			health_block.visible = false
		else:
			health_block.visible = false

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
			var duplicate = health_block.duplicate()
			health_container.add_child(duplicate)
	
	# update visibility of health blocks
	for i in range(health_container.get_child_count()):
		var health_block = health_container.get_child(i)
		health_block.visible = true
