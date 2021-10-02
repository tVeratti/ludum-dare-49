extends Spatial

var card:Card

onready var label = $label3D
onready var flip_animation:AnimationPlayer = $flip_animation


# Called when the node enters the scene tree for the first time.
func _ready():
	# set mesh texture?
	label.text = card.title


func flip():
	flip_animation.play("flip")


func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		flip()
		card.select()
