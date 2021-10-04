extends Resource

class_name Outcome


# An Outcome is triggered when the player selects a card during a scenario.
# Outcomes are assigned to either a success or fail state, and their modifiers are then applied.

export(String) var title:String = ''
export(String) var flavor_text:String = ''

# The modifier that increases the chance of "success" state
export(EmotionScale.TYPES) var modifier_type:int = EmotionScale.TYPES.RAGE

# These modifers are applied to the player's scales.
# 	Positive values push the scale towards the left emotion.
# 	Negative values push the scale towards the right emotion.
export(int) var rage_terror:int = 0
export(int) var vigilance_amazement:int = 0
export(int) var ecstasy_grief:int = 0
export(int) var admiration_loathing:int = 0


static func get_parts(outcome):
	var parts = []
	
	# Get all possible part values from the outcome
	_get_change(outcome.rage_terror, EmotionScale.SCALES.RAGE_TERROR, parts)
	_get_change(outcome.vigilance_amazement, EmotionScale.SCALES.VIGILANCE_AMAZEMENT, parts)
	_get_change(outcome.ecstasy_grief, EmotionScale.SCALES.ECSTASY_GRIEF, parts)
	_get_change(outcome.admiration_loathing, EmotionScale.SCALES.ADMIRATION_LOATHING, parts)
	
	return parts


static func get_relative_parts(outcome, player):
	var parts = get_parts(outcome)
	for part in parts:
		part.relative_increase = player.get_emotion_raw(part.type_key) > player.get_emotion_raw(part.opposite_type_key)

	return parts


static func _get_change(delta, key, parts):
	if delta != 0:
		parts.append(EmotionScale.get_change_info(delta, key))
	

func get_modifier(scale:int) -> int:
	match(scale):
		EmotionScale.SCALES.RAGE_TERROR: return rage_terror
		EmotionScale.SCALES.VIGILANCE_AMAZEMENT: return vigilance_amazement
		EmotionScale.SCALES.ECSTASY_GRIEF: return ecstasy_grief
		EmotionScale.SCALES.ADMIRATION_LOATHING: return admiration_loathing
		_: return 0
