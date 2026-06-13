class_name CharacterData
extends Resource

@export var max_health : float = 90.0
@export var base_move_speed : float = 4.5

# jump variables
@export_group("Jump Settings")
@export var horizontal_force : float = 7.0
@export var jump_height : float = 1.0
@export var jump_time_to_peak : float = 0.3
@export var jump_time_to_descent : float = 0.2

var jump_velocity : float :
	get :
		return  ((2.0 * jump_height) / jump_time_to_peak) * 1.0
var jump_gravity : float :
	get :
		return  ((-2.0 * jump_height) / ( jump_time_to_peak * jump_time_to_peak)) * -1.0
var fall_gravity : float :
	get :
		return  ((-2.0 * jump_height) / ( jump_time_to_peak * jump_time_to_descent)) * -1.0
