extends Control

# Play button
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Battle.tscn")

# Options button
func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/fake_options.tscn")

# Quit button
func _on_quit_pressed() -> void:
	get_tree().quit()
