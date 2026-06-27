class_name HitReceiver
extends Area3D

var fighter : Fighter
@export var hit_state_name : String

func initialize(fighter_init : Fighter):
	self.fighter = fighter_init

func hit(damage : int, knockback : int):
	print(fighter.player_id)
	if fighter.is_blocking:
		print("should be blockstun")
		fighter.state_machine.change_state("Blockstun")
	fighter.take_damage(self, damage)
