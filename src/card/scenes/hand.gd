extends Spatial

var CardScene = load("res://card/scenes/action_card.tscn")

const CARD_OFFSET = 0.1


onready var cards:Spatial = $cards


func _ready():
	Signals.connect("scenario_requested", self, "_on_scenario_requested")
	Signals.connect("scenario_started", self, "_on_scenario_started")
	Signals.connect("card_selected", self, "_on_card_selected")


func render_cards(scenario:Scenario):
	# Create new card nodes for new scenario.
	var offset:Vector3 = Vector3(0.3, 0, 0)
	for card in scenario.cards:
		var card_button = CardScene.instance()
		card_button.card = card
		card_button.target_offset = offset
		cards.add_child(card_button)
		
		offset += Vector3(card_button.get_size().x + CARD_OFFSET, 0, 0.01)


func _on_scenario_requested():
	# Remove cards from previous scenario.
	for card in cards.get_children():
		card.queue_free()


func _on_scenario_started(scenario:Scenario):
	render_cards(scenario)


func _on_card_selected(selected_card):
	for card in cards.get_children():
		card.disable()
