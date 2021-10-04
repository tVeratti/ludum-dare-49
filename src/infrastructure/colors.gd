extends Node

const RAGE = Color('B7191E')
const TERROR = Color('D06337')

const VIGILANCE = Color('ACC351')
const AMAZEMENT = Color('42B7AA')

const ECSTASY = Color('EAAF51')
const GRIEF = Color('2E70C7')

const ADMIRATION = Color('8CAC56')
const LOATHING = Color('C043A0')


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
