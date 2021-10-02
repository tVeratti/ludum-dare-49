extends Spatial

var CardScene = load("res://card/scenes/card.tscn")

const CARD_OFFSET = 0.1


onready var hand:Spatial = $hand


func _ready():
	Signals.connect("scenario_entered", self, "_on_scenario_entered")
	Signals.connect("card_selected", self, "_on_card_selected")


func render_cards(scenario:Scenario):
	# Remove any lingering cards from previous scenario.
	for card in hand.get_children():
		card.queue_free()
	
	# Create new card nodes for new scenario.
	var offset:Vector3 = Vector3(0.3, 0, 0)
	for card in scenario.cards:
		var card_button = CardScene.instance()
		card_button.card = card
		card_button.target_offset = offset
		hand.add_child(card_button)
		
		offset += Vector3(card_button.get_size().x + CARD_OFFSET, 0, 0.01)


func _on_scenario_entered(scenario:Scenario):
	render_cards(scenario)


func _on_card_selected(selected_card):
	for card in hand.get_children():
		card.disable()
