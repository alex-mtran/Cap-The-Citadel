extends Control

func _ready() -> void:
	Events.fake_game_mode = true
	Events.debug_mode = true
	
	print("Debug mode: " + str(Events.debug_mode))
	
	if not MainMusic.playing:
		MainMusic.play()
	
	if BattleMusic.playing:
		BattleMusic.stop()
	
	if not Events.database_created:
		Events.database = SQLite.new()
		Events.database.path = "res://data.db"
		Events.database.open_db()
		
		var table = {
			"id": {"data_type": "int", "primary_key": true, "not_null": true, "auto_increment": true},
			"curr_level_number": {"data_type": "int"},
			"max_level_unlocked": {"data_type": "int"},
			"attack_damage_bonus": {"data_type": "int"},
			"defense_armor_bonus": {"data_type": "int"}
		}
		
		Events.database.create_table("progress", table)
		
		Events.database_created = true

# Play button
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/fake_map.tscn")

# Options button
func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/fake_options.tscn")

# Quit button
func _on_quit_pressed() -> void:
	get_tree().quit()
