class_name HitReceiver
extends Area3D

var fighter : Fighter
@export var hit_state_name : String

func initialize(fighter : Fighter):
	self.fighter = fighter

func hit(damage : int):
	
	print("ouchi")
	fighter.take_damge(self, damage)
