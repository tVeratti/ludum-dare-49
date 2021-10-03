extends BaseCard

var scenario:Scenario


func _ready():
	label.text = scenario.title
	
	Signals.connect("scenario_requested", self, "_on_scenario_requested")


func activate():
	disable()
	Signals.emit_signal("scenario_started", scenario)


func _on_scenario_requested():
	queue_free()

