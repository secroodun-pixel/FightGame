class_name InputBuffer
extends Node

const BUFFER_SIZE : int = 20

var buffer : Array[InputPacket] = []

func _ready():
	for i in range(BUFFER_SIZE):
		buffer.push_front(InputPacket.new())

func recieve_input(packet : InputPacket):
	buffer.push_front(packet)
	
	if buffer.size() > BUFFER_SIZE:
		buffer.pop_back()

func is_pressed (input_string : String) -> bool:
	var packet : InputPacket = buffer[0]
	return packet.is_pressed(input_string)
	
func move_direction() -> int:
	var dir : int = 0
	
	if is_pressed("move_left"):
		dir -= 1
	if is_pressed("move_right"):
		dir += 1
		
	return dir
	
func was_pressed(input_string : String, buffer_window : int = 3) -> bool:
	for i in range(min(buffer_window, buffer.size())):
		if buffer[i].is_pressed(input_string):
			return true
	
	return false
