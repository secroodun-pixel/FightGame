class_name GameManager
extends Node

enum GameState
{
	LOADING,
	COUNTDOWN,
	PLAYING,
	UPGRADESELECT,
	ENDOFROUND,
	ENDED
}

@export var player_fighter_scene : PackedScene
@export var ai_fighter_scene : PackedScene
@export var camera_scene : PackedScene

@onready var fighter_0_spawn : Node3D = $Fighter0SPawn
@onready var fighter_1_spawn : Node3D = $Fighter1SPawn

@onready var player_1 : Fighter
@onready var player_2 : Fighter

@onready var countdown_anim : AnimationPlayer = $CountdownCanvasLayer/CountdownAnimation
@onready var countdown_timer : Timer = $CountdownTimer

@onready var current_round : int = 1
@onready var max_rounds : int = 3

@onready var endgame_text : Label = $CountdownCanvasLayer/EndgameText
@onready var endgame_timer : Timer = $EndgameTimer

@export var upgrade_database : UpgradeDatabase
var upgrade_not_selected : bool = true

var current_game_state : GameState

@onready var info_layer = $CanvasLayer/Label

@export_group("Upgrade groups")
@export var base_stat_upgrades : Array[UpgradeData]
@export var light_attack_upgrades : Array[UpgradeData]
@export var heavy_attack_upgrades : Array[UpgradeData]
@export var air_mobility_upgrades : Array[UpgradeData]

# vars for storing upgrade groups
var list_of_upgrade_groups : Dictionary = {}
var selected_group
var option_01
var option_02
var option_03

var player_1_selection
var player_2_selection

func _ready() -> void:
	GlobalEvents.FighterDefeated.connect(_on_fighter_defeated)
	GlobalEvents.ReadyToSelectUpgrades.connect(_start_selecting_upgrades)
	GlobalEvents.UpgradeSelected.connect(_lock_upgrades)
	
	# populate dictionary of upgrade groups
	list_of_upgrade_groups = {
	"Base_Stats" : base_stat_upgrades,
	"Light_Attack": light_attack_upgrades,
	"Heavy_Attack" : heavy_attack_upgrades,
	"Air_Mobility" : air_mobility_upgrades,
	}
	
	_change_game_state(GameState.LOADING)
		
func _change_game_state(game_state : GameState):
	# set current game state
	current_game_state = game_state
	info_layer.text = GameState.find_key(current_game_state)
	
	# loading
	if game_state == GameState.LOADING:
		_setup_fighters()
		
	# switch to countdown
	elif game_state == GameState.COUNTDOWN:
		# play start countdown
		countdown_anim.play("countdown")
		countdown_timer.start()		
		
	# switch to end of round	
	elif game_state == GameState.ENDOFROUND:
		pass
		
	elif game_state == GameState.UPGRADESELECT:
		endgame_text.visible = false

	# switch to game end	
	elif game_state == GameState.ENDED:
		# game over timer
		endgame_timer.start()
		
	GlobalEvents.GameStateChanged.emit(current_game_state)

func _setup_fighters():
	var right_fighter_scene : PackedScene

	# determine if we need player or vs ai setup
	if GameConfig.game_mode == GameConfig.GameMode.PLAYER_VS_PLAYER:
		right_fighter_scene = ai_fighter_scene
		# right_fighter_scene = player_fighter_scene
	elif GameConfig.game_mode == GameConfig.GameMode.PLAYER_VS_AI:
		right_fighter_scene = ai_fighter_scene
	
	# set up fighters	
	var left_fighter : Fighter = _spawn_fighter(player_fighter_scene)
	var right_fighter : Fighter = _spawn_fighter(right_fighter_scene)
	
	# wait for the fighters to be spawned before setting their info
	await right_fighter.tree_entered
	
	# set up fighter positions, ids, and opponents
	left_fighter.global_position = fighter_0_spawn.global_position
	right_fighter.global_position = fighter_1_spawn.global_position
	
	left_fighter.player_id = 0
	right_fighter.player_id = 1
	
	left_fighter.opponent = right_fighter
	right_fighter.opponent = left_fighter
	
	left_fighter.game_manager = self
	right_fighter.game_manager = self
	
	player_1 = left_fighter
	player_2 = right_fighter

	player_1.character = load("res://Data/golem_data.tres")
	player_2.character = load("res://Data/character_data.tres")
	
	player_1._calculate_stats()
	player_2._calculate_stats()
	
	_setup_camera(player_1, player_2)
	
	# change state to countdown
	_change_game_state(GameState.COUNTDOWN)
	
func _spawn_fighter (fighter_scene : PackedScene) -> Fighter:
	# create fighter and add as child of the scene
	var fighter : Fighter = fighter_scene.instantiate()
	get_tree().root.get_node("Main").add_child.call_deferred(fighter)
	return fighter
	
func _setup_camera(player_1_pos : Fighter, player_2_pos : Fighter):	
	# plug fighters into camera
	var camera : Camera3D = _spawn_camera(camera_scene)
	# plug in fighters
	camera.target_a = player_1_pos
	camera.target_b = player_2_pos

func _spawn_camera(game_cam : PackedScene) -> Camera3D:
	# create camera and add as child of the scene
	var camera : Camera3D = game_cam.instantiate()
	get_tree().root.get_node("Main").add_child(camera)
	return camera

func _on_fighter_defeated(fighter : Fighter):
	# show player win text
	endgame_text.visible = true
	if fighter.player_id == 0:
		endgame_text.text = "Player 2 wins"
	elif fighter.player_id == 1:
		endgame_text.text = "Player 1 wins"
		
	_change_game_state(GameState.ENDOFROUND)
	
func _on_countdown_timer_timeout() -> void:
	_change_game_state(GameState.PLAYING)

func _on_endgame_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	
func _get_upgrade_group():
	# get a random group from the upgrade list
	selected_group = list_of_upgrade_groups.keys().pick_random()
	print(light_attack_upgrades)
	option_01 = list_of_upgrade_groups[selected_group][0]
	option_02 = list_of_upgrade_groups[selected_group][1]
	option_03 = list_of_upgrade_groups[selected_group][2]
	
func _start_selecting_upgrades(_fighter):
	# get the upgrade group
	_get_upgrade_group()
	
	# hide end game text
	endgame_text.visible = false
	
	# begin selecting upgrades
	GlobalEvents.BeginSelectingUpgrades.emit(option_01, option_02, option_03)
	_change_game_state(GameState.UPGRADESELECT)
	
func _go_to_next_round():
	current_round += 1
	print("now going into round ", current_round)
	_reset_positions(player_1)
	_reset_positions(player_2)

	# reset and recalculate stats for next round
	player_1._calculate_stats()
	player_2._calculate_stats()	
	
	GlobalEvents.GoToNextRound.emit(player_1)
	GlobalEvents.GoToNextRound.emit(player_2)

	# change the game state
	_change_game_state(GameState.COUNTDOWN)	
		
func _lock_upgrades(fighter : Fighter, upgrade : UpgradeData):
	fighter.active_upgrades.append(upgrade)
	
	if fighter == player_1:
		player_1_selection = upgrade
		#print(player_1, "chose", player_1_selection)
	elif fighter == player_2:
		player_2_selection = upgrade
		#print(player_2, "chose", player_2_selection)
	
	if player_1.has_selected_upgrade and player_2.has_selected_upgrade:
			_go_to_next_round()

func _reset_positions(fighter):
		if fighter == player_1:
			player_1.global_position = fighter_0_spawn.global_position
		elif fighter == player_2:
			player_2.global_position = fighter_1_spawn.global_position
		
		fighter.move_velocity = Vector3.ZERO
		fighter.velocity = Vector3.ZERO
		
		# set character states to starting states
		fighter.is_victorious = false
		fighter.is_defeated = false
		fighter.has_selected_upgrade = false
		
		fighter.state_machine.change_state("Standing")
