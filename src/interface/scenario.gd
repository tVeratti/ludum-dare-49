extends Control



onready var title = $layout/title
onready var flavor = $layout/flavor
onready var outcome_title = $layout/outcome_title
onready var outcome_flavor = $layout/outcome_flavor
onready var next:Button = $layout/next


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


func _on_scenario_ready(scenario):
	pass


func _on_scenario_started(scenario:Scenario):
	title.label = scenario.title
	yield(get_tree().create_timer(0.3), "timeout")
	flavor.label = scenario.flavor_text


func _on_outcome_triggered(_outcome:Outcome):
	outcome_title.label = _outcome.title
	outcome_flavor.label = _outcome.flavor_text
	next.visible = true
	next.disabled = false


func _on_next_pressed():
	Signals.emit_signal("scenario_requested")
	next.visible = false
	next.disabled = true
