extends Node


class_name EmotionScale

# An EmotionScale represents two opposite(ish) emotions whose value slides between them.
# If either extreme is reach (MIN or MAX) then the player is at risk of consequences.

enum TYPES { RAGE, TERROR, VIGILANCE, AMAZEMENT, ECSTASY, GRIEF, ADMIRATION, LOATHING }
enum SCALES { RAGE_TERROR, VIGILANCE_AMAZEMENT, ECSTASY_GRIEF, ADMIRATION_LOATHING }

# Map emotion types to their opposites to create a scale.
# [MIN_VALUE (0), MAX_VALUE (6)]
const SCALES_MAP:Dictionary = {
	SCALES.RAGE_TERROR: [TYPES.RAGE, TYPES.TERROR],
	SCALES.VIGILANCE_AMAZEMENT: [TYPES.VIGILANCE, TYPES.AMAZEMENT], 
	SCALES.ECSTASY_GRIEF: [TYPES.ECSTASY, TYPES.GRIEF], 
	SCALES.ADMIRATION_LOATHING: [TYPES.ADMIRATION, TYPES.LOATHING]
}


const MIN_VALUE:int = 0
const MAX_VALUE:int = 6
const NEUTRAL_VALUE:int = 3

var scale:int = SCALES.RAGE_TERROR
var value:int = NEUTRAL_VALUE setget _set_value

# Sometimes the game wants to know the values of individual emotions.
# Calculate it from these getters based on the current scale value.
var left:int setget , _get_left_value # 0, 1, 2
var right:int setget , _get_right_value # 4, 5, 6

var colors:Array setget , _get_colors


func _init(_scale):
	scale = _scale
	
	# Randomize initial value just a little bit
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	self.value = rng.randi_range(MIN_VALUE, MAX_VALUE)
	

func _set_value(v):
	# Check for the scale reaching extreme values
	if v >= MAX_VALUE: pass
	elif v <= MIN_VALUE: pass
	
	value = clamp(v, MIN_VALUE, MAX_VALUE)
	
	Signals.emit_signal("emotion_changed", self)


func _get_left_value():
	# value of 0 is maximum left
	# any value above 0 is further away
	return NEUTRAL_VALUE - clamp(value, MIN_VALUE, NEUTRAL_VALUE)


func _get_right_value():
	# value of 6 is maximum right
	# any value less than 6 is further away
	return clamp(value, NEUTRAL_VALUE, MAX_VALUE) - NEUTRAL_VALUE


func _get_colors():
	return Colors.get_colors(scale)


static func get_change_info(delta, key):
	var emotion = SCALES_MAP[key]
	var labels = get_labels(key)
	var colors = Colors.get_colors(key)
	
	var type
	var label
	var color
	
	if delta == 0: return
	elif delta < 0:
		type = emotion[0]
		label = labels[0]
		color = colors[0]
	else:
		type = emotion[1]
		label = labels[1]
		color = colors[1]
	
	return [type, abs(delta), label, color]


static func get_labels(s):
	var keys = TYPES.keys()
	var mapped_scale = SCALES_MAP[s]
	return [
		keys[mapped_scale[0]],
		keys[mapped_scale[1]]
	]
