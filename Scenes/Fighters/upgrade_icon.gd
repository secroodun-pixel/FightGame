extends TextureRect

@export var atlas_texture: Texture2D
@export var x_index: int = 0
@export var y_index: int = 0
@export var icon_size: int = 128

var atlas: AtlasTexture

func _ready() -> void:
	# get the texture for the images
	atlas = AtlasTexture.new()
	atlas.atlas = atlas_texture
	texture = atlas
	update_region()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_region():
	# position image
	
	var x = x_index * icon_size
	var y = y_index * icon_size
	atlas.region = Rect2(x, y, icon_size, icon_size)
