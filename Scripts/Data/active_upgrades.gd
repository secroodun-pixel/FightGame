class_name ActiveUpgrades
extends Resource

# script for storing currently active upgrades
var active_upgrades : Array[String] = []

# base stat upgrades
var increase_health : int = 0
var increase_speed : float = 1.0 # speed multiplier, so 1 here is base speed

# heavy attacks
var can_charge : bool = false
