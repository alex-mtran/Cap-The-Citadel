extends Control

func _ready() -> void:
	Events.debug_mode = true
	
	if not MainMusic.playing:
		MainMusic.play()
	
	if BattleMusic.playing:
		BattleMusic.stop()

# Back button
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/fake_menu.tscn")

# Mute button
func _on_mute_pressed() -> void:
	if not AudioServer.is_bus_mute(AudioServer.get_bus_index("Master")):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
