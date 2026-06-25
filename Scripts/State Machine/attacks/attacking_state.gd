class_name AttackingState
extends State

@export var damage : int
@export var animation_name : String

@export var forward_force : float = 5.0

var duration : float
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

@export var hit_sender : HitSender
@export var hit_detect_start_time : float
@export var hit_detect_end_time : float

var has_hit : bool = false
var is_divekicking : float

func _stamina_cost () -> float:
	return 0

func can_enter () -> bool:
	if Time.get_unix_time_from_system() < cooldown_end_time:
		return false
	
	return stamina_controller.current_stamina >= _stamina_cost()

func enter():
	super.enter()
	
	# play animation
	animation.set_animation(animation_name)

	has_hit = false
	
	# consume stamina
	stamina_controller.consume_stamina(_stamina_cost())

func update(delta : float):
	super.update(delta)
	
	# active hit frames
	if local_time >= hit_detect_start_time and local_time <= hit_detect_end_time:
		var hit : HitReceiver = hit_sender.detect_hit()
		
		if hit and has_hit == false:
			has_hit = true
			hit.hit(damage)
	
	# exit hit state when attack duration ends
	if local_time >= duration:
		state_machine.change_state("Standing")
		return

func exit():
	super.exit()
	cooldown_end_time = Time.get_unix_time_from_system() + cooldown

func divekick():
	fighter.add_force(forward_force * fighter.forward_direction)
