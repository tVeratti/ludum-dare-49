extends Resource

class_name Card


export(String) var flavor_text:String = ''

# The modifier that increases the chance of "success" state
export(EmotionScale.TYPES) var modifier_type:int = EmotionScale.TYPES.RAGE

# Outcome resources
export(Resource) var success_outcome
export(Resource) var fail_outcome
