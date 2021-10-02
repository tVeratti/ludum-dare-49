extends Spatial

onready var camera:Camera = get_viewport().get_camera()
onready var layout:MarginContainer = $layout
onready var label:Label = $layout/label

var text:String = '' setget _set_text


func _ready():
	_set_text(text)


func _process(delta):
	if is_instance_valid(camera) and is_instance_valid(label):
		# Render the 2d root according to the 3d translation.
		var screen_position = camera.unproject_position(global_transform.origin)
		var offset = layout.rect_size / 2
		layout.set_position(Vector2(screen_position.x - offset.x, screen_position.y - offset.y))


func _set_text(value):
	text = value
	if is_instance_valid(label):
		label.text = value
