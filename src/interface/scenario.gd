extends Control



onready var title:Label = $title
onready var flavor:Label = $flavor
onready var outcome:Label = $outcome
onready var next:Button	= $next


func _ready():
	Signals.connect("scenario_entered", self, "_on_scenario_entered")
	Signals.connect("outcome_triggered", self, "_on_outcome_triggered")


func _on_scenario_entered(scenario:Scenario):
	title.text = scenario.title
	flavor.text = scenario.flavor_text
	
	# Hide previous outcome information
	outcome.visible = false

	

func _on_outcome_triggered(_outcome:Outcome):
	outcome.text = "%s\n%s" % [_outcome.title, _outcome.flavor_text]
	outcome.visible = true
	
	next.visible = true
	next.disabled = false


func _on_next_pressed():
	Signals.emit_signal("scenario_requested")
	next.visible = false
	next.disabled = true
