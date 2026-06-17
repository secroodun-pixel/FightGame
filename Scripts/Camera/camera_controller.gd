extends Camera3D

# get players
@export var target_a : Node3D
@export var target_b : Node3D

# camera smoothing
@export var smoothing : float
@export var zoom_curve : Curve

# camera shake variables
var intensity : float = 0.0

@export var shake_amount : float = 0.05
@export var shake_damping : float = 10.0

func _ready() -> void:
	GlobalEvents.FighterDamaged.connect(_on_fighter_damaged)

func _on_fighter_damaged(fighter : Fighter):
	intensity = shake_amount

func _physics_process(delta: float) -> void:
	_camera_follow(delta)
	
	# camera shake
	if intensity > 0:
		intensity = lerpf(intensity, 0, delta * shake_damping)
		h_offset = randf_range(-intensity, intensity)
		v_offset = randf_range(-intensity, intensity)

func _camera_follow(delta):
	return
	# get center between players, then distance
	var center_pos : Vector3 = target_a.global_position.lerp(target_b.global_position, .5)
	var distance : float = target_a.global_position.distance_to(target_b.global_position)
	
	# move camera
	position.x = lerp(position.x,center_pos.x, smoothing * delta)
	position.z = zoom_curve.sample(distance)
