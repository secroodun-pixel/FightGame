class_name InputBuffer
extends Node

const BUFFER_SIZE : int = 20

var buffer : Array[InputPacket] = []
var held_inputs : Dictionary ={}

func _ready():
	for i in range(BUFFER_SIZE):
		buffer.push_front(InputPacket.new())
		
func recieve_input(packet : InputPacket):
	# put new inputs in front, get rid of entries in back
	buffer.push_front(packet)
	if buffer.size() > BUFFER_SIZE:
		buffer.pop_back()
	
	# remove something from being marked held if not pressed
	for input_string in packet.inputs:
		if not packet.is_pressed(input_string):
			held_inputs.erase(input_string)
		
func is_pressed(input_string : String) -> bool:
	var packet : InputPacket = buffer[0]
	return packet.is_pressed(input_string)

func just_pressed(input_string : String) -> bool:
	# make sure we have buffer entries
	if buffer.size() < 2:
		return false
	
	# check that current packet is different than previous
	var current_packet : InputPacket = buffer[0]
	var previous_packet : InputPacket = buffer[1]
	return(
		current_packet.is_pressed(input_string)
		and not previous_packet.is_pressed(input_string)
	)

func just_released(input_string : String) -> bool:
	# make sure we have buffer entries
	if buffer.size() < 2:
		return false
	
	# check that current packet is different than previous
	var current_packet : InputPacket = buffer[0]
	var previous_packet : InputPacket = buffer[1]
	return(
		not current_packet.is_pressed(input_string)
		and previous_packet.is_pressed(input_string)
	)

#func was_pressed(input_string : String, buffer_window : int = BUFFER_SIZE) -> bool:
	## it was not just pressed if it is in held inputs
	#if held_inputs.has(input_string):
		#return false
	#
	## if it is pressed within the buffer window, 
	## it was pressed recently enough
	#for i in range(min(buffer_window, buffer.size())):
		#if buffer[i].is_pressed(input_string):
			#return true
	#
	## if none of the above, it was not pressed
	#return false
	
func was_pressed(input_string : String, buffer_window : int = BUFFER_SIZE) -> bool:
	# look through buffer size, checking current and last inputs
	for i in range(min(buffer_window, buffer.size() - 1)):
		var new_packet : InputPacket = buffer[i]
		var previous_packet : InputPacket = buffer[i+1]
		
		# make sure the recent input is not already within the range
		var new_press := (
			new_packet.is_pressed(input_string)
			and not previous_packet.is_pressed(input_string)
		)
		if new_press:
			return true
	
	# if none of the above, it was not pressed
	return false
	
func pressed_in_buffer(input_string : String, buffer_window : int = 1) -> bool:
	for i in range(min(buffer_window, buffer.size())):
		if buffer[i].is_pressed(input_string):
			return true
	
	return false
	
func move_direction() -> int:
	var dir : int = 0
	
	if is_pressed("move_left"):
		dir -= 1
	if is_pressed("move_right"):
		dir += 1
		
	return dir

func is_being_held(input_string : String) -> void:
	held_inputs[input_string] = true
	
	
	
