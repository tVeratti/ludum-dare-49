extends Control



onready var title:Label = $title
onready var flavor:Label = $flavor
onready var outcome:Label = $outcome
onready var next:Button = $next


func _ready():
	Signals.connect("scenario_requested", self, "_on_scenario_requested")
	Signals.connect("scenario_ready", self, "_on_scenario_ready")
	Signals.connect("scenario_started", self, "_on_scenario_started")
	Signals.connect("outcome_triggered", self, "_on_outcome_triggered")


func _on_scenario_requested():
	# Clear out the previous scenario
	title.text = ""
	flavor.text = ""
	outcome.text = ""


func _on_scenario_ready(scenario):
	pass


func _on_scenario_started(scenario:Scenario):
	title.text = scenario.title
	flavor.text = scenario.flavor_text


func _on_outcome_triggered(_outcome:Outcome):
	outcome.text = "%s\n%s" % [_outcome.title, _outcome.flavor_text]	
	next.visible = true
	next.disabled = false


func _on_next_pressed():
	Signals.emit_signal("scenario_requested")
	next.visible = false
	next.disabled = true
