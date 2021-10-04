extends Control

export(EmotionScale.SCALES) var scale:int = EmotionScale.SCALES.RAGE_TERROR

onready var progress:ProgressBar = $margin/layout/progress
onready var left_label:Label = $margin/layout/left
onready var left_symbol:TextureRect = $margin/layout/left_symbol
onready var right_label:Label = $margin/layout/right
onready var right_symbol:TextureRect = $margin/layout/right_symbol
onready var background:Panel = $background

onready var value_tween:Tween = $value_tween
onready var animations:AnimationPlayer = $animations

var colors


func _ready():
	background.visible = false
	
	colors = Colors.get_colors(scale)
	
	var fg:StyleBoxFlat = StyleBoxFlat.new()
	fg.bg_color = colors[1]
	progress.set('custom_styles/fg', fg)
	
	var bg:StyleBoxFlat = StyleBoxFlat.new()
	bg.bg_color = colors[0]
	progress.set('custom_styles/bg', bg)
	
	var labels = EmotionScale.get_labels(scale)
	left_label.text = labels[1]
	right_label.text = labels[0]
	
	var ends = EmotionScale.SCALES_MAP[scale]
	left_symbol.texture = Symbols.get_symbol(ends[1])
	right_symbol.texture = Symbols.get_symbol(ends[0])
	
	Signals.connect("emotion_changed", self, "_on_emotion_changed")


func _on_emotion_changed(emotion:EmotionScale):
	if emotion.scale == scale:
		value_tween.interpolate_property(progress, 'value', progress.value, emotion.value, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.3)
		value_tween.start()
		
		if emotion.value <= EmotionScale.MIN_VALUE or emotion.value >= EmotionScale.MAX_VALUE:
			background.visible = true
			background.modulate = colors[0] if emotion.value <= 1 else colors[1]
			animations.play("highlight")
		else:
			background.visible = false
			animations.stop()
