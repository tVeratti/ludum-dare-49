extends Node


class_name EmotionScale

# An EmotionScale represents two opposite(ish) emotions whose value slides between them.
# If either extreme is reach (MIN or MAX) then the player is at risk of consequences.

enum TYPES { RAGE, TERROR, VIGILANCE, AMAZEMENT, ECSTASY, GRIEF, ADMIRATION, LOATHING }

# Map emotion types to their opposites to create a scale.
# [MIN_VALUE (0), MAX_VALUE (7)]
const SCALES:Dictionary = {
	RAGE_TERROR = [TYPES.RAGE, TYPES.TERROR],
	VIGILANCE_AMAZEMENT = [TYPES.VIGILANCE, TYPES.AMAZEMENT], 
	ECSTASY_GRIEF = [TYPES.ECSTASY, TYPES.GRIEF], 
	ADMIRATION_LOATHING = [TYPES.ADMIRATION, TYPES.LOATHING]
}

const MIN_VALUE:int = 0
const MAX_VALUE:int = 7

var scale:Array = SCALES.RAGE_TERROR
var value:int = 2 setget _set_value


func _init(_scale):
	scale = _scale
	

func _set_value(v):
	# Check for the scale reaching extreme values
	if v >= MAX_VALUE: pass
	elif v <= MIN_VALUE: pass
	
	value = clamp(v, MIN_VALUE, MAX_VALUE)
	
	Signals.emit_signal("emotion_scale_changed", self)


