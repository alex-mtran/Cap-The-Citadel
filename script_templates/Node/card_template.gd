# meta-name: Card Logic
# meta_description: What happens when a card is played.
extends Card


func apply_effects(targets: Array[Node]) -> void:
	print("My card has been played!")
	print("targets: %s" % targets)
