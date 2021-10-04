extends Spatial

class_name BaseCard

const HOVER_OFFSET = 0.1
const HOVER_SCALE = Vector3(1.2, 1.2, 1)

var target_offset:Vector3 = Vector3.ZERO

onready var camera:Camera = get_viewport().get_camera()

onready var front_mesh:Sprite3D = $display/front_mesh
onready var back_mesh:Sprite3D = $display/back_mesh
onready var move_tween:Tween = $move_tween
onready var look_tween:Tween = $look_tween
onready var scale_tween:Tween = $look_tween
onready var flip_audio:AudioStreamPlayer = $flip_audio
onready var hover_audio:AudioStreamPlayer = $hover_audio
onready var place_audio:AudioStreamPlayer = $place_audio
onready var label = $display/label3D
onready var display = $display

onready var card_parts = $Viewport/card_parts

var disabled:bool = false
var hovered:bool = false
var target_origin:Vector3
var target_hover:Vector3

var positioned:bool = false


func _ready():
	# Snapshot some resting postional values.
	target_origin = global_transform.origin + target_offset
	var camera_direction = (camera.global_transform.origin - target_origin).normalized()
	target_hover = target_origin + (camera_direction * HOVER_OFFSET)
	
	# Move to its starting offset.
	if target_offset.length() > 0:
		move_tween.interpolate_property(self, "translation", translation, target_offset, 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		move_tween.start()
		
		yield(get_tree().create_timer(0.3), "timeout")
		var pitch_mod = rand_range(-0.1, 0.1)
		place_audio.pitch_scale = 1 + pitch_mod
		place_audio.play()


func set_card_back(texture:Texture):
	back_mesh.texture = texture


func set_card_front(material:SpatialMaterial):
	pass


func disable():
	disabled = true


func enable():
	disabled = false


func flip():
	tween_look(Vector3(0, 180, 0))
	tween_scale(Vector3.ONE)
#	tween_origin(target_hover)
	flip_audio.play()


func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
	if not disabled:
		if event is InputEventMouseMotion:
#			var look_offset = click_position - Vector3(0, 0, 10)
#			look_at(look_offset, Vector3.UP)
			if not hovered: tween_scale(HOVER_SCALE)
		elif event is InputEventMouseButton and event.pressed:
			flip()
			activate()


func activate():
	pass # overwrite by action or scenario


func hover():
	pass # overwrite by action or scenario


func tween_origin(target):
	pass
#	move_tween.interpolate_property(self, "global_transform:origin", global_transform.origin, target, 0.2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	move_tween.start()
#	


func tween_scale(target):
	scale_tween.interpolate_property(self, "scale", scale, target, 0.2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	scale_tween.start()



func tween_look(target):
	look_tween.interpolate_property(self, "rotation_degrees", rotation_degrees, target, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	look_tween.start()


func _on_Area_mouse_entered():
	if not disabled:
		hovered = true
		hover()
		tween_scale(HOVER_SCALE)
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		
		# Modify the pitch just a TINY bit...
		var pitch_mod = rand_range(-0.1, 0.1)
		hover_audio.pitch_scale = 1 + pitch_mod
		hover_audio.play()


func _on_Area_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	if not disabled:
		hovered = false
		Signals.emit_signal("card_unhovered")
		tween_scale(Vector3.ONE)
		tween_look(Vector3.ZERO)


func _on_move_tween_tween_all_completed():
	positioned = true
