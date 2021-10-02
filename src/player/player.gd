extends Node

class_name Player

# Emotions
# ----------------------------
var emotions:Dictionary = {
	[EmotionScale.SCALES.RAGE_TERROR]: EmotionScale.new(EmotionScale.SCALES.RAGE_TERROR),
	[EmotionScale.SCALES.VIGILANCE_AMAZEMENT]: EmotionScale.new(EmotionScale.SCALES.VIGILANCE_AMAZEMENT),
	[EmotionScale.SCALES.ECSTASY_GRIEF]: EmotionScale.new(EmotionScale.SCALES.ECSTASY_GRIEF),
	[EmotionScale.SCALES.ADMIRATION_LOATHING]: EmotionScale.new(EmotionScale.SCALES.ADMIRATION_LOATHING),
}

# Quick references to the above emotions dictionary
# Naming convention is important to understand which side each emotion is on.
# Example `rage_terror`: rage is MIN (0) / terror is MAX (7)
var rage_terror setget , _get_rage_terror
var vigilance_amazement setget , _get_vigilance_amazement
var ecstasy_grief setget , _get_ecstasy_grief
var admiration_loathing setget , _get_admiration_loathing


func _ready():
	Signals.connect("outcome_triggered", self, "_on_outcome_triggered")


# Emotions Getters
# ----------------------------
func _get_rage_terror(): emotions[EmotionScale.SCALES.RAGE_TERROR]
func _get_vigilance_amazement(): emotions[EmotionScale.SCALES.VIGILANCE_AMAZEMENT]
func _get_ecstasy_grief(): emotions[EmotionScale.SCALES.ECSTASY_GRIEF]
func _get_admiration_loathing(): emotions[EmotionScale.SCALES.ADMIRATION_LOATHING]


# Signals
# ----------------------------
func _on_outcome_triggered(outcome:Outcome):
	# Apply emotion modifiers from the outcome
	pass
