class_name AttackingState
extends State

@export var damage : int
@export var animation_name : String

@export var hit_stun : float = 5.0
@export var knockback_on_hit : float = 5.0

@export var block_stun : float = 2.0
@export var knockback_on_block : float = 2.0
@export var duration : float

@export var forward_force : float

var indefinite_duration : float = 10.0
var attack_length : float

var windup_length : float
var charge_length : float
var active_length : float
var recovery_length : float

var attack_end_length : float
var early_out_time : float

@export var cooldown : float
var cooldown_end_time : float

var is_charging : bool = false
@export var min_charge_time : float
@export var max_charge_time : float

@export var hit_sender : HitSender
@export var hit_detect_start_time : float
@export var hit_detect_end_time : float

var has_hit : bool = false

# charge variables
@export var base_speed : float = 1
@export var charge_speed : float = 0.3
@export var charge_time : float = 0.0
var move_speed_while_charging : float = 0.5

# divekick vars
var is_divekicking : float
@export var vertical_divekick : float
@export var horizontal_divekick : float

#func _stamina_cost () -> float:
	#return 0

func can_enter () -> bool:
	#if Time.get_unix_time_from_system() < cooldown_end_time:
		#return false
	#
	return true
	#return stamina_controller.current_stamina >= _stamina_cost()

func enter():
	super.enter()
	
	# play animation
	animation.set_animation(animation_name)

	# set start of attack variables
	has_hit = false
	
	# consume stamina
	#stamina_controller.consume_stamina(_stamina_cost())

func update(delta : float):
	super.update(delta)
	
	# active hit frames
	if (local_time >= hit_detect_start_time # for being passed active start
	and local_time <= hit_detect_end_time): # for being before active end
		# detect a hit
		var hit : HitReceiver = hit_sender.detect_hit()
		if (hit) and has_hit == false:
			# do not hit if opponent is blocking
			if not fighter.opponent.is_blocking:
				has_hit = true
				hit.hit(damage, knockback_on_hit)
			elif fighter.opponent.is_blocking:
				has_hit = true
				fighter.opponent.state_machine.change_state("Blockstun")
	else:
		pass
	
	# exit hit state when attack duration ends
	if local_time >= duration:
		state_machine.change_state("Standing")
		return
	
	# upgrade related behavior
	charge_movement()
	
	if input_buffer.is_pressed("block") and fighter.is_on_floor():
		if is_charging and fighter.can_block_cancel_charge:
			state_machine.change_state("Blocking")

	# apply jump gravity
	if not fighter.is_on_floor():
		apply_jump_gravity(delta)
		
func exit():
	super.exit()
	cooldown_end_time = Time.get_unix_time_from_system() + cooldown

func divekick():
	fighter.add_force(forward_force * fighter.forward_direction)
	
func charge_movement():
	# allow movement during charge
	if is_charging and fighter.can_move_while_charging:
		# set movement direction
		var move_dir : int = input_buffer.move_direction()
		
		# movement
		fighter.move_velocity.x = (move_dir 
									* fighter.move_speed
									* move_speed_while_charging)

	elif is_charging and fighter.is_on_floor():
		fighter.move_velocity.x = 0.0
