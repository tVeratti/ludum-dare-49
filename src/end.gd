extends MarginContainer

var CardParts = load("res://card/scenes/card_parts.tscn")
var SmolFont = preload("res://assets/fonts/smol.tres")


const CARD_OFFSET = 0.6

onready var result = $margin/story/result
onready var feeling = $margin/story/feeling
onready var cards:HBoxContainer = $margin/story/cards

onready var input_timer:Timer = $input_timer


func show_end(player, results):
	input_timer.start()
	
	var scale = player.get_most_extreme_scale()
	var extreme = scale.extreme
	
	if scale.value >= EmotionScale.MAX_VALUE or scale.value <= EmotionScale.MIN_VALUE:
		result.label = "You do not feel emotionally stable."
		
		feeling.label = "You feel very %s" % EmotionScale.LABELS_MAP[extreme]
		feeling.modulate = scale.color
	else:
		result.label = "You have regained your emotional stability!"
	
	render_results(results)


func render_results(results):
	# Create summary of cards and outcomes
	for result in results:
		var scenario = result[0]
		var outcome = result[1]
		
		var container = VBoxContainer.new()
		
		var label = Label.new()
		label.set("custom_fonts/font", SmolFont)
		label.text = outcome.title
		label.align = Label.ALIGN_CENTER
		container.add_child(label)
		
		var card_parts = CardParts.instance()
		card_parts.outcome = outcome
		container.add_child(card_parts)
		
		cards.add_child(container)
		card_parts.render_parts()



func _on_quit_pressed():
	if input_timer.is_stopped():
		get_tree().quit()


func _on_restart_pressed():
	if input_timer.is_stopped():
		Signals.emit_signal("start")
		queue_free()


func _on_input_timer_timeout():
	$margin/story/quit.disabled = false
	$margin/story/restart.disabled = false
