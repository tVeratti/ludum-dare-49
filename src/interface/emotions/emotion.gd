extends Control

export(EmotionScale.SCALES) var scale:int = EmotionScale.SCALES.RAGE_TERROR

onready var progress:ProgressBar = $layout/progress
onready var left_label:Label = $layout/left
onready var right_label:Label = $layout/right


func _ready():
	var colors = Colors.get_colors(scale)
	
	var fg:StyleBoxFlat = StyleBoxFlat.new()
	fg.bg_color = colors[0]
	progress.set('custom_styles/fg', fg)
	
	var bg:StyleBoxFlat = StyleBoxFlat.new()
	bg.bg_color = colors[1]
	progress.set('custom_styles/bg', bg)
	
	var keys = EmotionScale.TYPES.keys()
	var mapped_scale = EmotionScale.SCALES_MAP[scale]
	left_label.text = keys[mapped_scale[0]]
	right_label.text = keys[mapped_scale[1]]
	
	Signals.connect("emotion_changed", self, "_on_emotion_changed")


func _on_emotion_changed(emotion:EmotionScale):
	if emotion.scale == scale:
		progress.value = emotion.value

