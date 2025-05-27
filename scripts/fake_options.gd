extends Control

func _ready() -> void:
	if not MainMusic.playing:
		MainMusic.play()

# Back button
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/fake_menu.tscn")

# Mute button
func _on_mute_pressed() -> void:
	if MainMusic.volume_db >= 0:
		MainMusic.volume_db = -100
	else:
		MainMusic.volume_db = 0
