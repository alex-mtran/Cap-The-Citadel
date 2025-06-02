extends Control

const BATTLE_SCENE = preload("res://Scenes/Battle.tscn")

@onready var level_1_button: Button = $Level1_Button
@onready var level_2_button: Button = $Level2_Button
@onready var level_3_button: Button = $Level3_Button
@onready var congratulations_text: Label = $CongratsLabel

func _ready() -> void:
	Events.fake_game_mode = true
	Events.debug_mode = true
	
	if not MainMusic.playing:
		MainMusic.play()
	
	if BattleMusic.playing:
		BattleMusic.stop()
	
	if Events.max_level_unlocked == 1:
		level_2_button.disabled = true
		level_3_button.disabled = true
		congratulations_text.visible = false
	elif Events.max_level_unlocked == 2:
		level_3_button.disabled = true
		congratulations_text.visible = false
	elif Events.max_level_unlocked == 3:
		congratulations_text.visible = false

# Level 1 button
func _on_level_1_pressed() -> void:
	Events.curr_level_number = 1
	get_tree().change_scene_to_packed(BATTLE_SCENE)

# Level 2 button
func _on_level_2_pressed() -> void:
	Events.curr_level_number = 2
	get_tree().change_scene_to_packed(BATTLE_SCENE)

# Level 3 button
func _on_level_3_pressed() -> void:
	Events.curr_level_number = 3
	get_tree().change_scene_to_packed(BATTLE_SCENE)

# Menu button
func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/fake_menu.tscn")
