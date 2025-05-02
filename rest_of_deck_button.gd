class_name RestOfDeckButton
extends TextureButton
#
#func set_DeckPile(new_value: set)
	#DeckPile = new_value
	#
	#if not DeckPile 


func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://rest_of_deck_view.tscn")
