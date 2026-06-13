class_name HitReceiver
extends Area3D

var fighter : Fighter
@export var hit_state_name : String

func initialize(fighter_init : Fighter):
	self.fighter = fighter_init

func hit(damage : int):
	print("ouchi")
	fighter.take_damge(self, damage)
