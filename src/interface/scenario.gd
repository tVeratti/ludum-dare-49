extends Control



onready var title:Label = $title
onready var flavor:Label = $flavor
onready var cards:HBoxContainer = $cards
onready var outcome:Label = $outcome
onready var next:Button	= $next


func _ready():
	Signals.connect("scenario_entered", self, "_on_scenario_entered")
	Signals.connect("outcome_triggered", self, "_on_outcome_triggered")


func _on_scenario_entered(scenario:Scenario):
	title.text = scenario.title
	flavor.text = scenario.flavor_text
	
	# Remove any lingering cards from previous scenario.
	for card in cards.get_children():
		card.queue_free()
	
	# Hide previous outcome information
	outcome.visible = false
	
	# Create new card nodes for new scenario.
	for card in scenario.cards:
		# These should be their own scene eventually :)
		# Buttons for testing
		var card_button = Button.new()
		card_button.text = card.title
		card_button.hint_tooltip = card.flavor_text
		card_button.connect("pressed", self, "_on_card_pressed", [card])
		cards.add_child(card_button)


func _on_card_pressed(card:Card):
	card.select()
	

func _on_outcome_triggered(_outcome:Outcome):
	outcome.text = "%s\n%s" % [_outcome.title, _outcome.flavor_text]
	outcome.visible = true
	
	next.visible = true
	next.disabled = false


func _on_next_pressed():
	Signals.emit_signal("scenario_requested")
	next.visible = false
	next.disabled = true
