extends Node

signal start()

signal scenario_requested()
signal scenario_ready(scenario)
signal scenario_started(scenario)
signal hand_ready()
signal card_hovered(card)
signal card_unhovered(card)
signal card_selected(card)
signal outcome_triggered(outcome, player)
signal scenario_timed_out(card)

signal emotion_changed(emotion)
signal player_changed(player)
