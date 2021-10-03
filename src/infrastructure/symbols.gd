extends Node

const FaceAnger1 = preload("res://assets/textures/face_anger_1.png")
const FaceLoathing = preload("res://assets/textures/face_anger_2.png")
const FaceRage = preload("res://assets/textures/face_anger_3.png")

const FaceConfidence = preload("res://assets/textures/face_fear_1.png")
const FaceAdmiration = preload("res://assets/textures/face_fear_2.png")
const FaceTerror = preload("res://assets/textures/face_fear_3.png")

const FaceHappy = preload("res://assets/textures/face_sad_1.png")
const FaceSad2 = preload("res://assets/textures/face_sad_2.png")
const FaceSad3 = preload("res://assets/textures/face_sad_3.png")


static func get_symbol(type:int):
	match(type):
		EmotionScale.TYPES.RAGE: return FaceRage
		EmotionScale.TYPES.TERROR: return FaceTerror
		EmotionScale.TYPES.VIGILANCE: return FaceConfidence
		EmotionScale.TYPES.AMAZEMENT: return FaceSad2
		EmotionScale.TYPES.ECSTASY: return FaceHappy
		EmotionScale.TYPES.GRIEF: return FaceSad3
		EmotionScale.TYPES.ADMIRATION: return FaceAdmiration
		EmotionScale.TYPES.LOATHING: return FaceLoathing
		_: return FaceHappy
		
