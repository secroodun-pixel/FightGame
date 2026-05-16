class_name PlayerInputHandler
extends InputHandler


# Returns full action name with player_id

func _full_action_name (action : String) -> String:
	return str(fighter.player_id, "_", action)

func get_input_packet() -> InputPacket:
	var packet : InputPacket = InputPacket.new()
	
	packet.inputs["move_left"] = Input.is_action_pressed(_full_action_name("move_left"))
	packet.inputs["move_right"] = Input.is_action_pressed(_full_action_name("move_right"))
	packet.inputs["jump"] = Input.is_action_pressed(_full_action_name("jump"))
	packet.inputs["dash"] = Input.is_action_pressed(_full_action_name("dash"))
	packet.inputs["light_attack"] = Input.is_action_pressed(_full_action_name("light_attack"))
	packet.inputs["heavy_attack"] = Input.is_action_pressed(_full_action_name("heavy_attack"))
	
	return packet
