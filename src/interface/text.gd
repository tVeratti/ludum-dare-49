extends Control

onready var node:Label = $label
export(String) var label setget _set_label
export(float) var delay:float = 0.0
export(float) var speed:float = 1
export(bool) var auto_play:bool = true

onready var fade_animation:AnimationPlayer = $fade_animation


func _ready():
	fade_animation.stop(true)
	fade_animation.playback_speed = speed
	
	if auto_play: play()


func play():
	_set_label(label)


func _set_label(value):
	label = value
	
	if is_instance_valid(node):
		node.modulate = Color(1, 1, 1, 0)
		fade_animation.stop(true)
		yield(get_tree().create_timer(delay), "timeout")
		fade_animation.play("fade")
		node.text = label
