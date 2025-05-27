extends Control

func _ready() -> void:
	if not MainMusic.playing:
		MainMusic.play()
	
	if BattleMusic.playing:
		BattleMusic.stop()

# Level 1 button
func _on_level_1_pressed() -> void:
	Global.level_number = 1
	get_tree().change_scene_to_file("res://Scenes/Battle.tscn")

# Level 2 button
func _on_level_2_pressed() -> void:
	Global.level_number = 2
	get_tree().change_scene_to_file("res://Scenes/Battle.tscn")

# Level 3 button
func _on_level_3_pressed() -> void:
	Global.level_number = 3
	get_tree().change_scene_to_file("res://Scenes/Battle.tscn")

# Menu button
func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/fake_menu.tscn")
