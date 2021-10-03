extends BaseCard

var ActionBack = preload("res://assets/textures/cardback_soul.png")

var card:Card


func _ready():
	label.text = card.title
	set_card_back(ActionBack)
	
	Signals.connect("outcome_triggered", self, "_on_outcome_triggered")


func _on_outcome_triggered(outcome):
	# Render the outcome parts
	card_parts.outcome = outcome
	card_parts.render_parts()


func activate():
	Signals.emit_signal("card_selected", card)
