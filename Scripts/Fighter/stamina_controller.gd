class_name StaminaController
extends Node

signal StaminaUpdated(value : float)

@export var data : StaminaData

var current_stamina : float
var can_regen : bool = false

@onready var regen_timer : Timer = $StaminaRegenTimer

func _ready() -> void:
	# set regen timer and game start stamina
	regen_timer.wait_time = data.regen_delay
	_set_stamina(data.max_stamina)

func _physics_process(delta: float) -> void:
	# if we can't regen, do nothing
	if not can_regen:
		return
	
	# update the stamina
	var new_stamina : float = move_toward(current_stamina, data.max_stamina, data.regen_rate * delta)
	_set_stamina(new_stamina)

func _set_stamina(value : float):
	current_stamina = value
	StaminaUpdated.emit(current_stamina)

func consume_stamina(amount : float):
	# decrease stamina and prevent immediate regen
	_set_stamina(current_stamina - amount)
	can_regen = false
	regen_timer.stop()
	regen_timer.start()

func _on_stamina_regen_timer_timeout() -> void:
	# set that we can regen
	can_regen = true
