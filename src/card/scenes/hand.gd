extends Spatial

var CardScene = load("res://card/scenes/action_card.tscn")

const CARD_OFFSET = 0.6


onready var cards:Spatial = $cards


func _ready():
	visible = false
	Signals.connect("scenario_requested", self, "_on_scenario_requested")
	Signals.connect("scenario_started", self, "_on_scenario_started")
	Signals.connect("card_selected", self, "_on_card_selected")


func render_cards(scenario:Scenario):
	visible = true
	# Create new card nodes for new scenario.
	var index = 1
	for card in scenario.cards:
		var card_button = CardScene.instance()
		card_button.card = card
		card_button.target_offset = Vector3(0.1 + (CARD_OFFSET * index), -0.05, -.1)
		card_button.delay = index * 0.5
		
		# Delay each card just a tiny bit for a dealing effect
		cards.add_child(card_button)
		
		index += 1
	
	yield(get_tree().create_timer(index * 0.5), "timeout")
	Signals.emit_signal("hand_ready")


func _on_scenario_requested():
	# Remove cards from previous scenario.
	for card in cards.get_children():
		card.queue_free()


func _on_scenario_started(scenario:Scenario):
	yield(get_tree().create_timer(0.5), "timeout")
	render_cards(scenario)


func _on_card_selected(selected_card):
	for card in cards.get_children():
		card.disable()
