extends Spatial

# Gameplay:
# --------------------------
#	Select random scenario
#	Show card backs (flavor only)
#	Player selects card
#	Card flips over to reveal success or failure outcome
#	Apply modifiers to emotion scales

var ScenarioCard = load("res://scenario/scenes/scenario_card.tscn")
var End = load("res://end.tscn")

const MUSIC_FADE_DURATION = 4.0 # seconds
var music_resources = {
	"menu": preload("res://assets/audio/ld49_menumusic1.ogg"),
	"game_loop_1": preload("res://assets/audio/ld49_music1.ogg"),
	"game_loop_2": preload("res://assets/audio/ld49_music2.ogg")
}

# Add all scenarios that can appear in a game through editor
# From: /scenario/resources
export(Array, Resource) var scenarios:Array = []

var possible_scenarios:Array = []
var current_scenario:Scenario
var results:Array = []

var player:Player

onready var hand:Spatial = $hand
onready var river:Spatial = $scenario/river
onready var river_animations:AnimationPlayer = $scenario/river_animations

onready var interface = $CanvasLayer/interface
onready var interface_fade:Tween = $interface_fade
onready var music:AudioStreamPlayer = $music
onready var music_fade:Tween = $music_fade

var card_selected:bool = false


func _ready():
	player = Player.new()
	fade_music(music_resources.menu, 0)
	
	Signals.connect("start", self, "start")
	Signals.connect("card_selected", self, "_on_card_selected")
	Signals.connect("scenario_requested", self, "_on_scenario_requested")
	Signals.connect("scenario_started", self, "_on_scenario_started")
	Signals.connect("emotion_changed", self, "_on_emotion_changed")


func start():
	results = []
	
	player = Player.new()
	Signals.emit_signal("player_changed", player)
	
	# Get all possible scenarios once at start.
	# Order them based on that property.
	possible_scenarios = scenarios.duplicate()
	possible_scenarios.sort_custom(Scenario, "sort_self")
	
	interface_fade.interpolate_property(interface, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	interface_fade.start()
	fade_music(music_resources.game_loop_1, 2.0)
	next_scenario()


func next_scenario():
	var current_extreme = player.get_most_extreme_scale()
	current_scenario = null
	
	# Choose the next scenario based on the character's emotional balance.
	for scenario in possible_scenarios:
		if scenario.primary_scale == current_extreme.scale:
			current_scenario = scenario
			break
	
	# Erase from the array of possibilities so it cannot be chosen again.
	if current_scenario == null:
		current_scenario = possible_scenarios.pop_back()
	else: possible_scenarios.erase(current_scenario)
	
	# Reset all board stuff so they can click the scenario to "enter" it
	
	if current_scenario == null:
		# End of game
		var ending = End.instance()
		$CanvasLayer.add_child(ending)
		ending.show_end(player, results)
	else:
		var scenario_card = ScenarioCard.instance()
		scenario_card.scenario = current_scenario
		scenario_card.target_offset = Vector3(1, 0, 0)
		
		river_animations.stop(true)
		river.translation = Vector3.ZERO
		
		river.add_child(scenario_card)
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

	results.append([current_scenario, outcome])
	Signals.emit_signal("outcome_triggered", outcome, player)


func fade_music(to_audio:AudioStream, time_between:float = 2.0):
	if music.playing:
		music_fade.interpolate_property(music, 'volume_db', music.volume_db, -80, MUSIC_FADE_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		music_fade.start()
		yield(music_fade, "tween_completed")
	
	yield(get_tree().create_timer(time_between), "timeout")
	
	music.stream = to_audio
	music.play()
	
	music_fade.interpolate_property(music, 'volume_db', music.volume_db, 0, MUSIC_FADE_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	music_fade.start()


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


func _on_emotion_changed(emotion):
	Signals.emit_signal("player_changed", player)


func _on_music_fade_tween_completed(object, key):
	pass # Replace with function body.


func _on_music_finished():
	var next_audio
	if current_scenario == null:
		# No scenario means menu
		next_audio = music_resources.menu
	else:
		
		if music.stream == music_resources.game_loop_1:
			next_audio = music_resources.game_loop_2
		else:
			next_audio = music_resources.game_loop_1
	
	fade_music(next_audio)
