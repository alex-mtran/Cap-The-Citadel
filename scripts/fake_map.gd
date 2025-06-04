extends Control

const BATTLE_SCENE = preload("res://Scenes/Battle.tscn")

@onready var level_1_button: Button = $HBoxContainer/L1Button
@onready var level_2_button: Button = $HBoxContainer/L2Button
@onready var level_3_button: Button = $HBoxContainer/L3Button
@onready var level_4_button: Button = $HBoxContainer/L4Button
@onready var congratulations_text: Label = $CongratsLabel
@onready var save_text: Label = $SaveLabel
@onready var load_text: Label = $LoadLabel

func _ready() -> void:
	Events.debug_mode = true
	
	print("Debug mode: " + str(Events.debug_mode))
	
	if not MainMusic.playing:
		MainMusic.play()
	
	if BattleMusic.playing:
		BattleMusic.stop()
	
	if Events.max_level_unlocked == 1:
		level_2_button.disabled = true
		level_3_button.disabled = true
		level_4_button.disabled = true
		congratulations_text.visible = false
	elif Events.max_level_unlocked == 2:
		level_3_button.disabled = true
		level_4_button.disabled = true
		congratulations_text.visible = false
	elif Events.max_level_unlocked == 3:
		level_4_button.disabled = true
		congratulations_text.visible = false
	elif Events.max_level_unlocked == 4:
		congratulations_text.visible = false
	
	if Events.saved_game:
		load_text.visible = false
	elif Events.loaded_game:
		save_text.visible = false
	else:
		save_text.visible = false
		load_text.visible = false

# Level 1 button
func _on_level_1_pressed() -> void:
	Events.level_number = 1
	Events.saved_game = false
	Events.loaded_game = false
	get_tree().change_scene_to_packed(BATTLE_SCENE)

# Level 2 button
func _on_level_2_pressed() -> void:
	Events.level_number = 2
	Events.saved_game = false
	Events.loaded_game = false
	get_tree().change_scene_to_packed(BATTLE_SCENE)

# Level 3 button
func _on_level_3_pressed() -> void:
	Events.level_number = 3
	Events.saved_game = false
	Events.loaded_game = false
	get_tree().change_scene_to_packed(BATTLE_SCENE)

# Level 4 button
func _on_level_4_pressed() -> void:
	Events.level_number = 4
	Events.saved_game = false
	Events.loaded_game = false
	get_tree().change_scene_to_packed(BATTLE_SCENE)

# Menu button
func _on_menu_pressed() -> void:
	Events.saved_game = false
	Events.loaded_game = false
	get_tree().change_scene_to_file("res://Scenes/fake_menu.tscn")

# Save button
func _on_save_pressed() -> void:
	var save_query = """
		INSERT OR REPLACE INTO 
		progress(id, level_number, max_level_unlocked, attack_damage_bonus, defense_armor_bonus) 
		VALUES(0, ?, ?, ?, ?);
	"""
	
	var save_args = [
		Events.level_number,
		Events.max_level_unlocked,
		GameManager.attack_damage_bonus,
		GameManager.defense_armor_bonus
	]
	
	Events.database.query_with_bindings(save_query, save_args)
	
	get_tree().reload_current_scene()
	
	Events.saved_game = true
	Events.loaded_game = false
	
	print("Saved game progress")
	print("Current level number: " + str(Events.level_number))
	print("Maximum level unlocked: " + str(Events.max_level_unlocked))
	print("Attack damage bonus: " + str(GameManager.attack_damage_bonus))
	print("Defense armor bonus: " + str(GameManager.defense_armor_bonus))

# Load button
func _on_load_pressed() -> void:
	var result = Events.database.select_rows("progress", "id = 0", ["*"])
	
	if result.size() > 0:
		Events.level_number = result[0]["level_number"]
		Events.max_level_unlocked = result[0]["max_level_unlocked"]
		GameManager.attack_damage_bonus = result[0]["attack_damage_bonus"]
		GameManager.defense_armor_bonus = result[0]["defense_armor_bonus"]
	
	get_tree().reload_current_scene()
	
	Events.saved_game = false
	Events.loaded_game = true
	
	print("Loaded game progress")
	print("Current level number: " + str(Events.level_number))
	print("Maximum level unlocked: " + str(Events.max_level_unlocked))
	print("Attack damage bonus: " + str(GameManager.attack_damage_bonus))
	print("Defense armor bonus: " + str(GameManager.defense_armor_bonus))
