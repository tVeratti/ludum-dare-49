extends Node

const RAGE = Color('FF0000')
const TERROR = Color('FF6A00')
const VIGILANCE = Color('B6FF00')
const AMAZEMENT = Color('00FF90')
const ECSTASY = Color('FFD800')
const GRIEF = Color('0094FF')
const ADMIRATION = Color('10FF00')
const LOATHING = Color('FF00F6')


const COLOR_MAP = {
	EmotionScale.TYPES.RAGE: RAGE,
	EmotionScale.TYPES.TERROR: TERROR,
	EmotionScale.TYPES.VIGILANCE: VIGILANCE,
	EmotionScale.TYPES.AMAZEMENT: AMAZEMENT,
	EmotionScale.TYPES.ECSTASY: ECSTASY,
	EmotionScale.TYPES.GRIEF: GRIEF,
	EmotionScale.TYPES.ADMIRATION: ADMIRATION,
	EmotionScale.TYPES.LOATHING: LOATHING,
}


static func get_colors(scale):
	var test  = EmotionScale.SCALES_MAP[scale]
	var left_emotion = EmotionScale.SCALES_MAP[scale][0]
	var left_color:Color = Colors.COLOR_MAP[left_emotion]
	
	var right_emotion = EmotionScale.SCALES_MAP[scale][1]
	var right_color:Color = Colors.COLOR_MAP[right_emotion]
	
	return [left_color, right_color, left_color.blend(right_color)]
