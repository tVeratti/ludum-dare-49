extends BaseCard

var ActionBack = preload("res://assets/textures/cardback_soul.png")

var card:Card


func _ready():
	label.text = card.title
	set_card_back(ActionBack)


func activate():
	Signals.emit_signal("card_selected", card)
