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

const LABELS_MAP = {
	TYPES.RAGE: "angry",
	TYPES.TERROR: "afraid",
	TYPES.VIGILANCE: "uptight",
	TYPES.AMAZEMENT: "overwhelmed",
	TYPES.ECSTASY: "manic",
	TYPES.GRIEF: "sad",
	TYPES.ADMIRATION: "awestruck",
	TYPES.LOATHING: "frustrated",
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
var extreme:int setget , _get_extreme

var colors:Array setget , _get_colors
var color:Color setget , _get_color # Color for which side is more extreme


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


func _get_extreme():
	var map = SCALES_MAP[scale]
	if value > NEUTRAL_VALUE: return map[1]
	else: return map[0]


func _get_colors():
	return Colors.get_colors(scale)


func _get_color():
	return Colors.COLOR_MAP[_get_extreme()]


static func get_change_info(delta, key):
	var emotion = SCALES_MAP[key]
	var labels = get_labels(key)
	var colors = Colors.get_colors(key)
	
	var part = OutcomePart.new()
	part.scale_key = key
	part.delta = abs(delta)
	
	var type
	var label
	var color
	
	if delta == 0: return null
	elif delta < 0:
		part.type_key = emotion[0]
		part.opposite_type_key = emotion[1]
		part.label = labels[0]
		part.color = colors[0]
	else:
		part.type_key = emotion[1]
		part.opposite_type_key = emotion[0]
		part.label = labels[1]
		part.color = colors[1]
	
	return part


static func get_labels(s):
	var keys = TYPES.keys()
	var mapped_scale = SCALES_MAP[s]
	return [
		keys[mapped_scale[0]],
		keys[mapped_scale[1]]
	]
