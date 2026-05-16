class_name FighterVisual
extends Node


var models : Array[MeshInstance3D]

@export var hit_material : StandardMaterial3D
@export var model_root : Node3D

@onready var fighter : Fighter = $".."

@export var outfit_materials : Array[StandardMaterial3D]
@export var outfit_models : Array[MeshInstance3D]

func _ready():
	for child in model_root.find_children("*", "MeshInstance3D", true):
		models.append(child)
		
	GlobalEvents.FighterDamaged.connect(_hit_flash)
	
	_set_oufit(fighter.player_id)
		
func _hit_flash(fighter : Fighter):
	# return if the damaged fighter is not this one
	if self.fighter != fighter:
		return
		
	# flash by applying material overlay
	for model : MeshInstance3D in models:
		model.material_overlay = hit_material
	
	# wait a moment	
	await get_tree().create_timer(0.05).timeout
	
	# remove material overlay
	for model : MeshInstance3D in models:
		model.material_overlay = null

func _set_oufit(outfit_index : int):
	for model : MeshInstance3D in outfit_models:
		model.set_surface_override_material(0, outfit_materials[outfit_index])
