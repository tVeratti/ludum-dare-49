extends Spatial

# Gameplay:
# --------------------------
#	Select random scenario
#	Show card backs (flavor only)
#	Player selects card
#	Card flips over to reveal success or failure outcome
#	Apply modifiers to emotion scales


# Add all scenarios that can appear in a game through editor
# From: /scenario/resources
export(Array, Resource) var scenarios:Array = []

var possible_scenarios:Array = []
var current_scenario:Scenario

var player:Player = Player.new()


func _ready():
	randomize()
	
	# Get all possible scenarios once at start.
	# This array will be used for random selection.
	possible_scenarios = scenarios.duplicate()
	possible_scenarios.shuffle()
	
	next_scenario()
	
	Signals.connect("card_selected", self, "_on_card_selected")
	Signals.connect("scenario_requested", self, "_on_scenario_requested")


func next_scenario():
	# Pop from the array of possibilities so it cannot be chosen again.
	current_scenario = possible_scenarios.pop_back()
	
	if current_scenario == null:
		# End of game
		pass
	else:
		Signals.emit_signal("scenario_entered", current_scenario)


# Signals
# ----------------------------


func _on_card_selected(card:Card):
	var relevant_emotion_value = player.get_emotion_raw(card.modifier_type)
	var success_modifier = relevant_emotion_value * 10 # %
	
	var success_roll = int(rand_range(0, 100)) 
	var success_threshold = 50 - success_modifier
	
	var outcome
	if success_roll >= success_threshold:
		outcome = card.success_outcome
	else:
		outcome = card.fail_outcome
	
	if outcome == null: print("%s is missing an outcome definition" % card.title)
	
	Signals.emit_signal("outcome_triggered", outcome)


func _on_scenario_requested():
	next_scenario()
