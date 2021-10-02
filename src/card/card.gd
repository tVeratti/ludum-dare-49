extends Resource

class_name Card

export(String) var title:String = ''
export(String) var flavor_text:String = ''

export(Array, Resource) var outcomes:Array = []


func select():
	Signals.emit_signal("card_selected", self)
