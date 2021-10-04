extends Control


onready var flavor = $flavor


func _ready():
	Signals.connect("card_hovered", self, "_on_card_hovered")
	Signals.connect("card_unhovered", self, "_on_card_unhovered")


func _on_card_hovered(card:Card):
	flavor.label = card.title


func _on_card_unhovered():
	flavor.label = ""
