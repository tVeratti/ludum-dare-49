extends Spatial

# Gameplay:
# --------------------------
#	Select random scenario
#	Show card backs (flavor only)
#	Player selects card
#	Card flips over to reveal success or failure outcome
#	Apply modifiers to emotion scales


# Add all scenarios that can appear in a game through editor
# From: /scenario/resources
export(Array, Resource) var scenarios:Array = []
