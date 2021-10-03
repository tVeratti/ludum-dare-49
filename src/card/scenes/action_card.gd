extends BaseCard

var ActionBack = preload("res://assets/textures/cardback_soul.png")

var card:Card


func _ready():
	label.text = card.title
	set_card_back(ActionBack)
	
	Signals.connect("outcome_triggered", self, "_on_outcome_triggered")
	Signals.connect("scenario_timed_out", self, "_on_scenario_timed_out")


func _on_outcome_triggered(outcome):
	# Render the outcome parts
	card_parts.outcome = outcome
	card_parts.render_parts()


func _on_scenario_timed_out(random_card):
	if random_card == card:
		flip()
		activate()


func hover():
	Signals.emit_signal("card_hovered", card)


func activate():
	Signals.emit_signal("card_selected", card)
