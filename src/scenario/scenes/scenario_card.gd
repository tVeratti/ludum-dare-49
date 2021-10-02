extends BaseCard

var scenario:Scenario


func _ready():
#	label.text = scenario.title
	Signals.connect("scenario_ready", self, "_on_scenario_ready")


func activate():
	Signals.emit_signal("scenario_started", scenario)


func _on_scenario_ready(new_scenario):
	scenario = new_scenario
	label.text = scenario.title
