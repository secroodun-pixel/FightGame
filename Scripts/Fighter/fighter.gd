class_name Fighter
extends CharacterBody3D

@export var character : CharacterData

@export var player_id : int ## whether player is 0 or 1
@export var opponent : Fighter ## player's opponent

@onready var collision_capsule : CollisionShape3D = $Collision_Capsule

var current_health : int = 1
var base_health : int = 1

@export var input_handler : InputHandler
@export var input_buffer : InputBuffer
@export var state_machine : StateMachine
@export var game_manager : GameManager

# jump vars
var move_velocity : Vector3
var forward_direction : int
var drag : float = 0.8

var just_entered_jump : bool = true

# end round vars
var is_victorious : bool = false
var is_defeated : bool = false
var is_upgrading : bool = false

# basic allowances
var can_control : bool = false 
var is_invulnerable : bool = false
var is_blocking : bool = false

# upgrades
var active_upgrades : Array[UpgradeData] = []

@onready var has_selected_upgrade : bool = false

# variables for fighter stats and upgrades from character data
#region base character variables
var max_health : int
var base_move_speed : float
var move_speed : float

# jump variables
var horizontal_force : float = 0.0 # used in jumps
var jump_height : float
var jump_time_to_peak : float
var jump_time_to_descent : float

# jump math
var jump_velocity : float :
	get :
		return  ((2.0 * jump_height) / jump_time_to_peak) * 1.0
var jump_gravity : float :
	get :
		return  ((-2.0 * jump_height) / ( jump_time_to_peak * jump_time_to_peak)) * -1.0
var fall_gravity : float :
	get :
		return  ((-2.0 * jump_height) / ( jump_time_to_peak * jump_time_to_descent)) * -1.0

#endregion

# attack availabities
var can_charge_heavy : bool ## if heavy attack charge is unlocked
var can_charge_light : bool ## if light attack charge is unlocked
var can_move_while_charging : bool = true # if charge movement is unlocked

# air movement
var has_air_influence : bool ## if air influence is unlocked
var has_air_hover : bool = true ## if hover is unlocked

var can_hover : bool = true ## if player is currently able to start hovering

func _ready():
	for child in find_children("*", "HitReceiver", true, false):
		child.initialize(self)
	for child in find_children("*", "HitSender", true, false):
		child.initialize(self)
	
	_update_facing_direction.call_deferred()
	
func _physics_process(delta: float) -> void:
	# check if we are in playing mode, can control is true if so
	if not game_manager.current_game_state == game_manager.GameState["PLAYING"]:
		can_control = false
	else:
		can_control = true
		
	# prevent control if we cannot control and are not in a state where
	# the player can do inputs
	if (not can_control 
	and not game_manager.current_game_state == game_manager.GameState["UPGRADESELECT"]
	and not game_manager.current_game_state == game_manager.GameState["ENDOFROUND"]
	):
		return
	
	# 1. Get the input packet
	var input_packet : InputPacket = input_handler.get_input_packet()
	
	# 2. Receive the input in the buffer
	input_buffer.recieve_input(input_packet)
	
	# 3. Process the input in the state machine
	state_machine.update(delta)
	
	# 4. Update facing direction
	if (state_machine.current_state == state_machine.states["Standing"]
		or state_machine.current_state == state_machine.states["Hovering"]):
		_update_facing_direction()
		
	# 5. Process movement
	_movement(delta)
	
func _update_facing_direction():
	if global_position.x < opponent.global_position.x:
		forward_direction = 1
		rotation_degrees.y = 90
	else:
		forward_direction = -1
		rotation_degrees.y = -90

func _movement(_delta : float):	
	
	velocity.x = move_velocity.x
	velocity.y = move_velocity.y
	
	_root_motion(_delta)
	
	move_and_slide()

func get_custom_gravity() -> float:
	return character.jump_gravity if move_velocity.y < 0.0 else character.fall_gravity
	
func take_damage(hit_receiver : HitReceiver, damage_amount : float):
	# make sure fighter is not already defeated
	if is_defeated or is_invulnerable:
		return
	
	# deal damage and emit that we were hit
	current_health -= damage_amount
	GlobalEvents.FighterDamaged.emit(self)
	
	# check for health being depleted
	if current_health <= 0:
		current_health = 0
		defeat()
		opponent.victory()
		
	# get hit if still alive
	else:
		state_machine.change_state(hit_receiver.hit_state_name)

func victory():
	is_victorious = true
	state_machine.change_state("Victorious")
		
func defeat():
		is_defeated = true
		state_machine.change_state("Defeated")
		GlobalEvents.FighterDefeated.emit(self)

func _calculate_stats():
	# reset stats, reusing base
	max_health = character.max_health + 1
	max_health += game_manager.current_round - 1
	
	#move_speed = character.base_move_speed
	move_speed = character.base_move_speed
	
	# jump variables
	horizontal_force = character.horizontal_force
	jump_height = character.jump_height
	jump_time_to_peak = character.jump_time_to_peak
	jump_time_to_descent = character.jump_time_to_descent

	# attack availabities
	can_charge_heavy = character.can_charge_heavy
	can_charge_light = character.can_charge_light
	
	# air movement
	has_air_influence = character.has_air_influence
	has_air_hover = character.has_air_hover

	# apply upgrades
	for upgrade in active_upgrades:
		upgrade.apply_upgrade(self)
		print(upgrade, " for ", player_id)

	# set current health after updating
	current_health = max_health

func _root_motion(_delta):
	var anim_tree = state_machine.animation.anim_tree
	
	# get root joint info
	var root_position : Vector3 = anim_tree.get_root_motion_position()

	velocity.x += (root_position.z / _delta) * forward_direction
	#var root_rotation : Quaternion = global_transform.basis.get_rotation_quaternion()
	#var root_velocity : Vector3 = (root_rotation * root_position) / _delta
	
