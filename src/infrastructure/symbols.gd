extends Node

const FaceAnger1 = preload("res://assets/textures/face_anger_1.png")
const FaceAnger2 = preload("res://assets/textures/face_anger_2.png")
const FaceAnger3 = preload("res://assets/textures/face_anger_3.png")

const FaceFear1 = preload("res://assets/textures/face_fear_1.png")
const FaceFear2 = preload("res://assets/textures/face_fear_2.png")
const FaceFear3 = preload("res://assets/textures/face_fear_3.png")

const FaceSad1 = preload("res://assets/textures/face_sad_1.png")
const FaceSad2 = preload("res://assets/textures/face_sad_2.png")
const FaceSad3 = preload("res://assets/textures/face_sad_3.png")


static func get_symbol(type:int):
	match(type):
		EmotionScale.TYPES.RAGE: return FaceAnger1
		EmotionScale.TYPES.TERROR: return FaceFear1
		_: return FaceSad1
		
