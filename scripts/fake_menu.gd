extends Control

func _ready() -> void:
	Events.fake_game_mode = true
	Events.debug_mode = true
	
	if not MainMusic.playing:
		MainMusic.play()
	
	if BattleMusic.playing:
		BattleMusic.stop()

# Play button
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/fake_map.tscn")

# Options button
func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/fake_options.tscn")

# Quit button
func _on_quit_pressed() -> void:
	get_tree().quit()
