extends Control

var Single = preload("res://assets/textures/cardfront_1.png")

var TopHalf = preload("res://assets/textures/cardfront_2_1.png")
var BottomHalf = preload("res://assets/textures/cardfront_2_2.png")

var TopThird = preload("res://assets/textures/cardfront_3_1.png")
var MidThird = preload("res://assets/textures/cardfront_3_2.png")
var BottomThird = preload("res://assets/textures/cardfront_3_3.png")

onready var layout:VBoxContainer = $layout


var outcome:Outcome
var parts:Array = []

func _ready():
	pass


func render_parts():
	parts = []
	
	# Get all possible part values from the outcome
	add_part_type(outcome.rage_terror, EmotionScale.SCALES.RAGE_TERROR)
	add_part_type(outcome.vigilance_amazement, EmotionScale.SCALES.VIGILANCE_AMAZEMENT)
	add_part_type(outcome.ecstasy_grief, EmotionScale.SCALES.ECSTASY_GRIEF)
	add_part_type(outcome.admiration_loathing, EmotionScale.SCALES.ADMIRATION_LOATHING)
	
	var backgrounds = []
	match(parts.size()):
		1: backgrounds = [Single]
		2: backgrounds = [TopHalf, BottomHalf]
		3: backgrounds = [TopThird, MidThird, BottomThird]
	
	for part in parts:
		var type = part[0]
		var container = CenterContainer.new()
		
		var bg = TextureRect.new()
		bg.texture = backgrounds.pop_front()
		bg.modulate = Colors.COLOR_MAP[type]
		container.add_child(bg)
		
		var facey = TextureRect.new()
		facey.texture = Symbols.get_symbol(type)
		container.add_child(facey)
		
#		var label = Label.new()
#		label.text = "%s" %  part[1]
#		container.add_child(label)
		
		layout.add_child(container)


func add_part_type(value, key):
	var emotion = EmotionScale.SCALES_MAP[key]
	var labels = EmotionScale.get_labels(key)
	
	var type
	var label
	
	if value == 0: return
	elif value < 0:
		type = emotion[0]
		label = labels[0]
	else:
		type = emotion[1]
		label = labels[1]
	
	parts.append([type, abs(value), label])
