extends Spatial

const HOVER_OFFSET = 0.8

var card:Card
var target_offset:Vector3 = Vector3.ZERO

onready var camera:Camera = get_viewport().get_camera()

onready var mesh:MeshInstance = $mesh
onready var move_tween:Tween = $move_tween
onready var look_tween:Tween = $look_tween
onready var flip_audio:AudioStreamPlayer = $flip_audio
onready var hover_audio:AudioStreamPlayer = $hover_audio
onready var label = $label3D

var disabled:bool = false
var target_origin:Vector3
var target_hover:Vector3


func _ready():
	# set mesh texture?
	label.text = card.title
	
	# Snapshot some resting postional values.
	target_origin = global_transform.origin + target_offset
	var camera_direction = (camera.global_transform.origin - target_origin).normalized()
	target_hover = target_origin + (camera_direction * HOVER_OFFSET)
	
	# Move to its starting offset.
	move_tween.interpolate_property(self, "translation", translation, target_offset, 1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	move_tween.start()


func disable():
	disabled = true


func flip():
	tween_look(Vector3(0, 180, 0))
	tween_origin(target_hover)
	flip_audio.play()


func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
	if not disabled:
		if event is InputEventMouseMotion:
			var look_offset = click_position - Vector3(0, 0, 20)
			look_at(look_offset, Vector3.UP)
		elif event is InputEventMouseButton and event.pressed:
			flip()
			card.select()


func get_size():
	return mesh.get_aabb().size


func tween_origin(target):
	move_tween.interpolate_property(self, "global_transform:origin", global_transform.origin, target, 0.2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	move_tween.start()


func tween_look(target):
	look_tween.interpolate_property(self, "rotation_degrees", rotation_degrees, target, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	look_tween.start()


func _on_Area_mouse_entered():
	if not disabled:
		tween_origin(target_hover)
		# Modify the pitch just a TINY bit...
		var pitch_mod = rand_range(-0.1, 0.1)
		hover_audio.pitch_scale = 1 + pitch_mod
		hover_audio.play()


func _on_Area_mouse_exited():
	if not disabled:
		tween_look(Vector3.ZERO)
		tween_origin(target_origin)


