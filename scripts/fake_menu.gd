extends Control

func _ready() -> void:
	Events.debug_mode = true
	
	print("Debug mode: " + str(Events.debug_mode))
	
	if not MainMusic.playing:
		MainMusic.play()
	
	if BattleMusic.playing:
		BattleMusic.stop()
	
	Events.database = SQLite.new()
	Events.database.path = "res://database/data.db"
	Events.database.open_db()
	
	var table = {
		"id": {"data_type": "integer", "primary_key": true, "not_null": true},
		"level_number": {"data_type": "integer", "not_null": true},
		"max_level_unlocked": {"data_type": "integer", "not_null": true},
		"attack_damage_bonus": {"data_type": "integer", "not_null": true},
		"defense_armor_bonus": {"data_type": "integer", "not_null": true}
	}
	
	Events.database.create_table("progress", table)

# Play button
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/fake_map.tscn")

# Options button
func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/fake_options.tscn")

# Quit button
func _on_quit_pressed() -> void:
	Events.database.close_db()
	get_tree().quit()
