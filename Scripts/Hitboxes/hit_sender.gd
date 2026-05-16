class_name HitSender
extends Area3D

var fighter : Fighter

func initialize(fighter : Fighter):
	self.fighter = fighter

func detect_hit() -> HitReceiver:
	var areas : Array[Area3D] = get_overlapping_areas()
	
	for area in areas:
		if area is not HitReceiver:
			continue
			
		if area.fighter.player_id == fighter.player_id:
			continue
			
		return area
	
	return null
