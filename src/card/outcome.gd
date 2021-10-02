extends Resource

class_name Outcome

# An Outcome is triggered when the player selects a card during a scenario.
# Outcomes are assigned to either a success or fail state, and their modifiers are then applied.

export(String) var title:String = ''
export(String) var flavor_text:String = ''

# These modifers are applied to the player's scales.
# 	Positive values push the scale towards the left emotion.
# 	Negative values push the scale towards the right emotion.
export(int) var rage_terror:int = 0
export(int) var vigilance_amazement:int = 0
export(int) var ecstasy_grief:int = 0
export(int) var admiration_loathing:int = 0


func get_modifier(scale:int) -> int:
	match(scale):
		EmotionScale.SCALES.RAGE_TERROR: return rage_terror
		EmotionScale.SCALES.VIGILANCE_AMAZEMENT: return vigilance_amazement
		EmotionScale.SCALES.ECSTASY_GRIEF: return ecstasy_grief
		EmotionScale.SCALES.ADMIRATION_LOATHING: return admiration_loathing
		_: return 0
