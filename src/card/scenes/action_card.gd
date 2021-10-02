extends BaseCard

var card:Card


func _ready():
	label.text = card.title


func activate():
	Signals.emit_signal("card_selected", card)
