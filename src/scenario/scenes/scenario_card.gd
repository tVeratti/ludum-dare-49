extends BaseCard

var scenario:Scenario

onready var float_animation:AnimationPlayer = $float_animation


func _ready():
	label.text = scenario.title
	float_animation.play("float")

	enable()
	Signals.connect("scenario_requested", self, "_on_scenario_requested")


func activate():
	disable()
	Signals.emit_signal("scenario_started", scenario)


func _on_scenario_requested():
	queue_free()

