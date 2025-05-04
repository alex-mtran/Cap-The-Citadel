class_name GraveyardDeckButton
extends TextureButton
#
#func set_DeckPile(new_value: set)
	#DeckPile = new_value
	#
	#if not DeckPile 


func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://graveyard_deck_view.tscn")
