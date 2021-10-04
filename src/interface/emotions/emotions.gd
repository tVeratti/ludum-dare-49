extends MarginContainer

onready var feeling = $emotions/feeling

const EMOTION_MAP = {
	EmotionScale.TYPES.RAGE: "angry",
	EmotionScale.TYPES.TERROR: "afraid",
	EmotionScale.TYPES.VIGILANCE: "uptight",
	EmotionScale.TYPES.AMAZEMENT: "overwhelmed",
	EmotionScale.TYPES.ECSTASY: "manic",
	EmotionScale.TYPES.GRIEF: "sad",
	EmotionScale.TYPES.ADMIRATION: "awestruck",
	EmotionScale.TYPES.LOATHING: "frustrated",
}

func _ready():
	Signals.connect("player_changed", self, "_on_emotion_changed")


func _on_emotion_changed(player:Player):
	if player != null:
		var scale = player.get_most_extreme_scale()
		var extreme = scale.extreme

		if scale.value >= EmotionScale.MAX_VALUE - 1 or scale.value <= EmotionScale.MIN_VALUE + 1:
			feeling.text = "You feel %s" % EMOTION_MAP[extreme]
			feeling.modulate = scale.color
		else:
			feeling.text = ""
