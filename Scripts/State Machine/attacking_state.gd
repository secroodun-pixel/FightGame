class_name AttackingState
extends State

@export var damage : int
@export var animation_name : String
@export var duration : float

@export var cooldown : float
var cooldown_end_time : float

@export var forward_force: float

@export var hit_sender : HitSender
var has_hit : bool = false
@export var hit_detect_start_time : float
@export var hit_detect_end_time : float

func can_enter () -> bool:
	if Time.get_unix_time_from_system() < cooldown_end_time:
		return false
	
	return true

func enter():
	super.enter()
	
	# play animation and add forward movement
	animation.set_animation(animation_name)
	fighter.add_force(forward_force *fighter.forward_direction)
	has_hit = false

func update(delta : float):
	super.update(delta)
	
	if local_time >= hit_detect_start_time and local_time <= hit_detect_end_time:
		var hit : HitReceiver = hit_sender.detect_hit()
		
		if hit and has_hit == false:
			has_hit = true
			hit.hit(damage)
	
	if local_time >= duration:
		state_machine.change_state("Standing")

func exit():
	super.exit()
	cooldown_end_time = Time.get_unix_time_from_system() + cooldown
