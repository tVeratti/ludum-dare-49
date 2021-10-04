extends Control

var TextScene = preload("res://interface/text.tscn")

onready var title = $layout/title
onready var flavor = $layout/flavor
onready var outcome_title = $layout/outcome_title
onready var outcome_flavor = $layout/outcome_flavor
onready var emotion_changes = $layout/emotion_changes
onready var next = $layout/press_any

var ready_for_next:bool = false

const EMOTION_ADJ_MAP = {
	EmotionScale.TYPES.RAGE: "angry",
	EmotionScale.TYPES.TERROR: "afraid",
	EmotionScale.TYPES.VIGILANCE: "vigilant",
	EmotionScale.TYPES.AMAZEMENT: "amazed",
	EmotionScale.TYPES.ECSTASY: "happy",
	EmotionScale.TYPES.GRIEF: "sad",
	EmotionScale.TYPES.ADMIRATION: "awe",
	EmotionScale.TYPES.LOATHING: "frustrated",
}


func _ready():
	next.visible = false
	
	Signals.connect("scenario_requested", self, "_on_scenario_requested")
	Signals.connect("scenario_ready", self, "_on_scenario_ready")
	Signals.connect("scenario_started", self, "_on_scenario_started")
	Signals.connect("outcome_triggered", self, "_on_outcome_triggered")


func _input(event):
	if ready_for_next and (event is InputEventKey or event is InputEventMouseButton):
		if event.pressed:
			Signals.emit_signal("scenario_requested")


func _on_scenario_requested():
	ready_for_next = false
	
	# Clear out the previous scenario
	title.label = ""
	flavor.label = ""
	outcome_title.label = ""
	outcome_flavor.label = ""
	next.visible = false
	
	for label in emotion_changes.get_children():
		label.queue_free()


func _on_scenario_ready(scenario):
	pass


func _on_scenario_started(scenario:Scenario):
	toggle_scenario(true)
	toggle_outcome(false)
	title.label = scenario.title
	flavor.label = scenario.flavor_text


func _on_outcome_triggered(_outcome:Outcome, player:Player):
	toggle_scenario(false)
	toggle_outcome(true)
	
	outcome_title.label = _outcome.title
	outcome_flavor.label = _outcome.flavor_text
	next.visible = true
	
	# Get emotional outcome parts
	var parts = Outcome.get_relative_parts(_outcome, player)
	for part in parts:
		var label = TextScene.instance()
		emotion_changes.add_child(label)
		var mod = "more" if part.relative_increase else "less"
		var color = Colors.COLOR_MAP[part.type_key] if part.relative_increase else Colors.COLOR_MAP[part.opposite_type_key]
		var text = EMOTION_ADJ_MAP[part.type_key] if part.relative_increase else EMOTION_ADJ_MAP[part.opposite_type_key]
		label.modulate = color
		label.label = "   You feel %s %s." % [mod, text]
	
	ready_for_next = true


func toggle_scenario(value):
	title.visible = value
	flavor.visible = value


func toggle_outcome(value):
	outcome_title.visible = value
	outcome_flavor.visible = value
