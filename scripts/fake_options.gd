extends Control

@onready var reset_text: Label = $ResetLabel

func _ready() -> void:
	Events.debug_mode = true
	
	print("Debug mode: " + str(Events.debug_mode))
	
	if not MainMusic.playing:
		MainMusic.play()
	
	if BattleMusic.playing:
		BattleMusic.stop()
	
	reset_text.visible = false

# Back button
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/fake_menu.tscn")

# Mute button
func _on_mute_pressed() -> void:
	if not AudioServer.is_bus_mute(AudioServer.get_bus_index("Master")):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)

# Reset button
func _on_reset_pressed() -> void:
	Events.curr_level_number = 1
	Events.max_level_unlocked = 1
	GameManager.attack_damage_bonus = 0
	GameManager.defense_armor_bonus = 0
	
	Events.database.delete_rows("progress", "")
	Events.database.drop_table("progress")
	
	reset_text.visible = true
