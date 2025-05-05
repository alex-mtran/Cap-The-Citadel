# class_name GraveyardDeckButton
extends TextureButton

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/ui/Graveyard_deck_view.tscn")
