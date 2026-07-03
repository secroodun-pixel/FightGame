class_name HitReceiver
extends Area3D

var fighter : Fighter
@export var hit_state_name : String

func initialize(fighter_init : Fighter):
	self.fighter = fighter_init

func hit(damage : int, _knockback : float):
	if fighter.is_blocking:
		fighter.state_machine.change_state("Blockstun")
	fighter.take_damage(self, damage)
