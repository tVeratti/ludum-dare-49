extends Control

onready var node:Label = $label
export(String) var label setget _set_label

onready var fade_animation:AnimationPlayer = $fade_animation


func _ready():
	fade_animation.play("fade")
	visible = true


func _set_label(value):
	label = value
	if is_instance_valid(node):
		fade_animation.stop(true)
		fade_animation.play("fade")
		node.text = label
