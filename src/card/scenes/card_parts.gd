extends Control

var Single = preload("res://assets/textures/cardfront_1.png")

var TopHalf = preload("res://assets/textures/cardfront_2_1.png")
var BottomHalf = preload("res://assets/textures/cardfront_2_2.png")

var TopThird = preload("res://assets/textures/cardfront_3_1.png")
var MidThird = preload("res://assets/textures/cardfront_3_2.png")
var BottomThird = preload("res://assets/textures/cardfront_3_3.png")

var SmolFont = preload("res://assets/fonts/smol.tres")

onready var layout:VBoxContainer = $layout


var outcome:Outcome
var parts:Array = []

func _ready():
	pass


func render_parts():
	parts = Outcome.get_parts(outcome)
	
	var backgrounds = []
	match(parts.size()):
		1: backgrounds = [Single]
		2: backgrounds = [TopHalf, BottomHalf]
		3: backgrounds = [TopThird, MidThird, BottomThird]
	
	for part in parts:
		var type = part.type_key
		var container = CenterContainer.new()
		
		var bg = TextureRect.new()
		bg.texture = backgrounds.pop_front()
		bg.modulate = Colors.COLOR_MAP[type]
		container.add_child(bg)
		
		var hbox = HBoxContainer.new()
		container.add_child(hbox)
		
		var facey = TextureRect.new()
		facey.texture = Symbols.get_symbol(type)
		hbox.add_child(facey)
		
		var label = Label.new()
		label.set("custom_fonts/font", SmolFont)
		label.set("custom_colors/font_color", Color.black)
		var mod = "+" if part.delta > 0 else "-"
		label.text = "%s%s" % [mod, abs(part.delta)]
		hbox.add_child(label)
		
		layout.add_child(container)


func add_part_type(value, key):
	var part = EmotionScale.get_change_info(value, key)
	parts.append(part)
