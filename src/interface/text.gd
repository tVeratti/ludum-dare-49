extends Control

onready var node:Label = $label
export(String) var label setget _set_label
export(float) var delay:float = 0.0
export(float) var speed:float = 1

onready var fade_animation:AnimationPlayer = $fade_animation


func _ready():
	fade_animation.playback_speed = speed
	yield(get_tree().create_timer(delay), "timeout")
	_set_label(label)
	visible = true


func _set_label(value):
	label = value
	if is_instance_valid(node):
		fade_animation.stop(true)
		fade_animation.play("fade")
		node.text = label
