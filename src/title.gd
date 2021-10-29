extends MarginContainer

onready var main = $main
onready var story = $story
onready var event_timer:Timer = $event_timer

var stage = 0

func _input(event):
	if (event is InputEventKey or event is InputEventMouseButton):
		if event.pressed:
			if stage == 0:
				stage = 1
				
				main.visible = false
				story.visible = true
				
				for text in story.get_children():
					text.play()
				
				event_timer.start()
			
			elif stage == 1 and event_timer.is_stopped():
				Signals.emit_signal("start")
				queue_free()
