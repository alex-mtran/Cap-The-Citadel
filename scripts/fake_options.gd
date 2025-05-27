extends Control

# Back button
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/fake_menu.tscn")

# Mute button
func _on_mute_pressed() -> void:
	pass
