extends Resource

class_name Scenario

enum TYPES { AGENCY, CHANCE }

export(String) var title:String = ''
export(String) var flavor_text:String = ''
export(TYPES) var type = TYPES.AGENCY
export(int) var order:int = 0
export(Array, Resource) var cards:Array = []

# Primary scale determines if this scenario will be selected when the character has an extreme
# imbalance of the current emotional scale.
export(EmotionScale.SCALES) var primary_scale:int = EmotionScale.SCALES.RAGE_TERROR

const DURATION:float = 30.0

var start_time:float
var time_left:float setget , _get_time_left


func start():
	start_time = OS.get_system_time_msecs()


static func sort_self(a, b):
	# Sort descending so that we can use pop_back
	return a.order > b.order


func _get_time_left():
	time_left = OS.get_system_time_msecs() - start_time
	return time_left
