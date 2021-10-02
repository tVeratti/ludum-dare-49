extends Resource

class_name Card

export(String) var title:String = ''
export(String) var flavor_text:String = ''

export(Array, Resource) var outcomes:Array = []


# Outcome resources
export(Resource) var success_outcome
export(Resource) var fail_outcome


func select():
	Signals.emit_signal("card_selected", self)
