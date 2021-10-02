extends Spatial

var CardScene = load("res://card/scenes/card.tscn")

onready var hand:Spatial = $hand

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("scenario_entered", self, "_on_scenario_entered")


func render_cards(scenario:Scenario):
	# Remove any lingering cards from previous scenario.
	for card in hand.get_children():
		card.queue_free()
	
	# Create new card nodes for new scenario.
	for card in scenario.cards:
		var card_button = CardScene.instance()
		card_button.card = card
		hand.add_child(card_button)


func _on_scenario_entered(scenario:Scenario):
	render_cards(scenario)
