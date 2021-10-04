extends Control

var TextScene = preload("res://interface/text.tscn")

onready var title = $layout/title
onready var flavor = $layout/flavor
onready var outcome_title = $layout/outcome_title
onready var outcome_flavor = $layout/outcome_flavor
onready var emotion_changes = $layout/emotion_changes

onready var next:Button = $layout/next

const EMOTION_ADJ_MAP = {
	EmotionScale.TYPES.RAGE: "more angry",
	EmotionScale.TYPES.TERROR: "more afraid",
	EmotionScale.TYPES.VIGILANCE: "more vigilant",
	EmotionScale.TYPES.AMAZEMENT: "more amazed",
	EmotionScale.TYPES.ECSTASY: "happier",
	EmotionScale.TYPES.GRIEF: "more sad",
	EmotionScale.TYPES.ADMIRATION: "more in awe",
	EmotionScale.TYPES.LOATHING: "more frustrated",
}


func _ready():
	Signals.connect("scenario_requested", self, "_on_scenario_requested")
	Signals.connect("scenario_ready", self, "_on_scenario_ready")
	Signals.connect("scenario_started", self, "_on_scenario_started")
	Signals.connect("outcome_triggered", self, "_on_outcome_triggered")


func _on_scenario_requested():
	# Clear out the previous scenario
	title.label = ""
	flavor.label = ""
	outcome_title.label = ""
	outcome_flavor.label = ""
	for label in emotion_changes.get_children():
		label.queue_free()


func _on_scenario_ready(scenario):
	pass


func _on_scenario_started(scenario:Scenario):
	toggle_scenario(true)
	toggle_outcome(false)
	title.label = scenario.title
	flavor.label = scenario.flavor_text


func _on_outcome_triggered(_outcome:Outcome):
	toggle_scenario(false)
	toggle_outcome(true)
	
	outcome_title.label = _outcome.title
	outcome_flavor.label = _outcome.flavor_text
	
	# Get emotional outcome parts
	var parts = Outcome.get_parts(_outcome)
	for part in parts:
		var label = TextScene.instance()
		emotion_changes.add_child(label)
		label.modulate = part[3]
		label.label = "   You feel %s." % EMOTION_ADJ_MAP[part[0]]
	
	next.visible = true
	next.disabled = false


func toggle_scenario(value):
	title.visible = value
	flavor.visible = value


func toggle_outcome(value):
	outcome_title.visible = value
	outcome_flavor.visible = value


func _on_next_pressed():
	Signals.emit_signal("scenario_requested")
	next.visible = false
	next.disabled = true
