class_name Fighter
extends CharacterBody3D

@export var character : CharacterData

@export var player_id : int
@export var opponent : Fighter

var current_health : int = 1
var max_health : int = 1

@export var input_handler : InputHandler
@export var input_buffer : InputBuffer
@export var state_machine : StateMachine
@export var game_manager : GameManager

# jump vars
var forward_direction : int
var move_velocity : Vector3
var horizontal_force : float
var drag : float = 0.8

var just_entered_jump : bool = true
var jump_start_blocker : float = 5.0

# allowances
var can_control : bool = false
var is_invulnerable : bool = false

var is_victorious : bool = false
var is_defeated : bool = false

@onready var has_selected_upgrade : bool = false

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
	if is_on_floor():
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

func add_force(force : float):
	horizontal_force += force

func _movement(delta : float):
	horizontal_force *= drag
	
	velocity.x = move_velocity.x + horizontal_force
	velocity.y = move_velocity.y
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
		add_force(forward_direction * -10)
		
func victory():
	is_victorious = true
	state_machine.change_state("Victorious")
		
func defeat():
		is_defeated = true
		state_machine.change_state("Defeated")
		GlobalEvents.FighterDefeated.emit(self)
