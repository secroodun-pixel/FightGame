class_name HitSender
extends Area3D

var fighter : Fighter

func initialize(fighter_init : Fighter):
	self.fighter = fighter_init

func detect_hit() -> HitReceiver:
	# get which areas overlap
	var areas : Array[Area3D] = get_overlapping_areas()
	
	for area in areas:
		if area is not HitReceiver:
			continue
			
		if area.fighter.player_id == fighter.player_id:
			continue
			
		return area
	
	return null
