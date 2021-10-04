extends Spatial

# Gameplay:
# --------------------------
#	Select random scenario
#	Show card backs (flavor only)
#	Player selects card
#	Card flips over to reveal success or failure outcome
#	Apply modifiers to emotion scales

var ScenarioCard = load("res://scenario/scenes/scenario_card.tscn")


# Add all scenarios that can appear in a game through editor
# From: /scenario/resources
export(Array, Resource) var scenarios:Array = []

var possible_scenarios:Array = []
var current_scenario:Scenario

var player:Player

onready var hand:Spatial = $hand
onready var river:Spatial = $scenario/river
onready var river_animations:AnimationPlayer = $scenario/river_animations

var card_selected:bool = false


func _ready():
	player = Player.new()
	
	# Get all possible scenarios once at start.
	# Order them based on that property.
	possible_scenarios = scenarios.duplicate()
	possible_scenarios.sort_custom(Scenario, "sort_self")
	
	next_scenario()
	
	Signals.connect("card_selected", self, "_on_card_selected")
	Signals.connect("scenario_requested", self, "_on_scenario_requested")
	Signals.connect("scenario_started", self, "_on_scenario_started")


func next_scenario():
	# Pop from the array of possibilities so it cannot be chosen again.
	current_scenario = possible_scenarios.pop_back()
	
	# Reset all board stuff so they can click the scenario to "enter" it
	
	if current_scenario == null:
		# End of game
		pass
	else:
		var scenario_card = ScenarioCard.instance()
		scenario_card.scenario = current_scenario
		scenario_card.target_offset = Vector3(1, 0, 0)
		
		river_animations.stop(true)
		river.translation = Vector3.ZERO
		
		river.add_child(scenario_card)
		print(current_scenario.title)
		Signals.emit_signal("scenario_ready", current_scenario)


# Signals
# ----------------------------


func _on_card_selected(card:Card):
	river_animations.stop()
	card_selected = true
	
	var roll_total:int = 0
	var roll_modifiers:Array = []
	var roll_ranges:Array = []
	var current_range:int = -1
	
	# I'm gonna trust indeces to stay the same...
	# roll_percentage[1] should be card.outcomes[1]
	
	# Get outcome success thresholds
	for outcome in card.outcomes:
		# Get the relevant emotion modifier based on the outcome's type.
		var relevant_emotion_value = max(player.get_emotion_raw(outcome.modifier_type), 1)
		roll_total += relevant_emotion_value
		roll_modifiers.append(relevant_emotion_value)
	
	for roll in roll_modifiers:
		var percentage = int((float(roll) / float(roll_total)) * 100)
		roll_ranges.append([current_range + 1, current_range + percentage])
		current_range += percentage
	
	var roll_result = int(rand_range(0, 99))
	var outcome
	for index in range(roll_ranges.size()):
		var roll_range = roll_ranges[index]
		if roll_result >= roll_range[0] and roll_result < roll_range[1]:
			outcome = card.outcomes[index]
			print("Outcome Roll: %s [%s - %s]" % [roll_result, roll_range[0], roll_range[1]])
			break

	if outcome == null: print("No outcome found on card %s" % card.title) 
	
	# Apply the outcome modifiers to the player's emotions
	player.rage_terror.value += outcome.rage_terror
	player.vigilance_amazement.value += outcome.vigilance_amazement
	player.ecstasy_grief.value += outcome.ecstasy_grief
	player.admiration_loathing.value += outcome.admiration_loathing

	Signals.emit_signal("outcome_triggered", outcome)


func _on_scenario_started(scenario):
	card_selected = false
	river_animations.play("move")
	river_animations.seek(0, true)


func _on_scenario_requested():
	next_scenario()


func _on_river_animation_finished(anim_name):
	# Select a random card since the animation timed out
	if not card_selected:
		var cards = current_scenario.cards.duplicate()
		cards.shuffle()
		
		Signals.emit_signal("scenario_timed_out", cards.pop_back())
