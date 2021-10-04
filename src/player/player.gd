extends Node

class_name Player

# Emotions
# ----------------------------
var emotions:Dictionary = {
	RAGE_TERROR = EmotionScale.new(EmotionScale.SCALES.RAGE_TERROR),
	VIGILANCE_AMAZEMENT = EmotionScale.new(EmotionScale.SCALES.VIGILANCE_AMAZEMENT),
	ECSTASY_GRIEF = EmotionScale.new(EmotionScale.SCALES.ECSTASY_GRIEF),
	ADMIRATION_LOATHING = EmotionScale.new(EmotionScale.SCALES.ADMIRATION_LOATHING),
}

# Quick references to the above emotions dictionary
# Naming convention is important to understand which side each emotion is on.
# Example `rage_terror`: rage is MIN (0) / terror is MAX (6)
var rage_terror setget , _get_rage_terror
var vigilance_amazement setget , _get_vigilance_amazement
var ecstasy_grief setget , _get_ecstasy_grief
var admiration_loathing setget , _get_admiration_loathing


func _ready():
	Signals.connect("outcome_triggered", self, "_on_outcome_triggered")


func get_most_extreme_scale():
	var most_extreme = emotions.RAGE_TERROR
	var extreme_value = EmotionScale.NEUTRAL_VALUE
	
	var scales = [
		emotions.RAGE_TERROR,
		emotions.VIGILANCE_AMAZEMENT,
		emotions.ECSTASY_GRIEF,
		emotions.ADMIRATION_LOATHING
	]
	var current = extreme_value
	for scale in scales:
		current = _get_extreme(scale)
		if current > extreme_value:
			most_extreme = scale
			extreme_value = current
	
	return most_extreme


func _get_extreme(scale:EmotionScale):
	if scale.left >= EmotionScale.NEUTRAL_VALUE:
		return scale.left
		
	return scale.right


func get_emotion_raw(type:int) -> int:
	match(type):
		EmotionScale.TYPES.RAGE: return self.rage_terror.left
		EmotionScale.TYPES.TERROR: return self.rage_terror.right
		EmotionScale.TYPES.VIGILANCE: return self.vigilance_amazement.left
		EmotionScale.TYPES.AMAZEMENT: return self.vigilance_amazement.right
		EmotionScale.TYPES.ECSTASY: return self.ecstasy_grief.left
		EmotionScale.TYPES.GRIEF: return self.ecstasy_grief.right
		EmotionScale.TYPES.ADMIRATION: return self.admiration_loathing.left
		EmotionScale.TYPES.LOATHING: return self.rage_terror.right
		_: return 0


# Emotions Getters
# ----------------------------
func _get_rage_terror(): return emotions.RAGE_TERROR
func _get_vigilance_amazement(): return emotions.VIGILANCE_AMAZEMENT
func _get_ecstasy_grief(): return emotions.ECSTASY_GRIEF
func _get_admiration_loathing(): return emotions.ADMIRATION_LOATHING


# Signals
# ----------------------------
func _on_outcome_triggered(outcome:Outcome):
	# Apply emotion modifiers from the outcome
	pass
