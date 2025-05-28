extends Node2D

@export var char_stats: CharacterStats

@onready var battle_ui: BattleUI = $BattleUI as BattleUI
@onready var player_handler: PlayerHandler = $PlayerHandler as PlayerHandler
@onready var enemy_handler: EnemyHandler = $EnemyHandler as EnemyHandler
@onready var player: Player = $Player as Player
@onready var panel: Panel = $BattleUI/Panel
@onready var label: Label = $BattleUI/Panel/Label
@onready var return_button: Button = $BattleUI/ReturnButton
@onready var mute_button: Button = $BattleUI/MuteButton

func _ready() -> void:
	# Temp code because normally we would want to keep health, deck, gold between battles
	if MainMusic.playing:
		MainMusic.stop()
	
	if not BattleMusic.playing:
		BattleMusic.play()
	
	panel.visible = false
	return_button.visible = true
	mute_button.visible = true
	var new_stats: CharacterStats = char_stats.create_instance()
	battle_ui.char_stats = new_stats
	player.stats = new_stats

	enemy_handler.child_order_changed.connect(_on_enemies_child_order_changed)
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)

	
	Events.player_turn_ended.connect(player_handler.end_turn)
	Events.player_hand_discarded.connect(enemy_handler.start_turn)
	Events.player_died.connect(_on_player_died)
	start_battle(new_stats)

	# safe quitter
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_handle_window_close()

func _handle_window_close() -> void:
	#battle_ended = true
	
	if Events.enemy_turn_ended.is_connected(_on_enemy_turn_ended):
		Events.enemy_turn_ended.disconnect(_on_enemy_turn_ended)
	
	if Events.player_turn_ended.is_connected(player_handler.end_turn):
		Events.player_turn_ended.disconnect(player_handler.end_turn)
	
	if Events.player_hand_discarded.is_connected(enemy_handler.start_turn):
		Events.player_hand_discarded.disconnect(enemy_handler.start_turn)
	
	if Events.player_died.is_connected(_on_player_died):
		Events.player_died.disconnect(_on_player_died)
	
	if enemy_handler and enemy_handler.child_order_changed.is_connected(_on_enemies_child_order_changed):
		enemy_handler.child_order_changed.disconnect(_on_enemies_child_order_changed)
	
	if battle_ui:
		battle_ui.set_process_mode(Node.PROCESS_MODE_DISABLED)
	if player_handler:
		player_handler.set_process_mode(Node.PROCESS_MODE_DISABLED)
	if enemy_handler:
		enemy_handler.set_process_mode(Node.PROCESS_MODE_DISABLED)
	if player:
		player.set_process_mode(Node.PROCESS_MODE_DISABLED)
	
	get_tree().call_group("enemies", "set_process_mode", Node.PROCESS_MODE_DISABLED)
	
	get_tree().quit()

func start_battle(stats: CharacterStats) -> void:
	#battle_ended = false
	enemy_handler.reset_enemy_actions()
	print("Battle has started!")
	print("Current bonuses: Attack: +", GameManager.get_attack_bonus(), " Defense: +", GameManager.get_defense_bonus())
	player_handler.start_battle(stats)

func _on_enemies_child_order_changed() -> void: 
	if enemy_handler.get_child_count() == 0:
		if return_button:
			return_button.visible = false
		
		if mute_button:
			mute_button.visible = false
	
		if label:
			label.text = "Level passed!"
			
		if panel:
			panel.visible = true
			
		print("Victory!")
		_show_victory_ui()
		
func _on_enemy_turn_ended() -> void:
	#if not battle_ended:
	player_handler.start_turn()
	enemy_handler.reset_enemy_actions()
	
func _on_player_died() -> void:
	if return_button:
		return_button.visible = false
	
	if mute_button:
		mute_button.visible = false
	
	if label:
		label.text = "Level failed!"
		
	if panel:
		panel.visible = true
		
	print("Game over!")
	_show_game_over_ui()

func _show_victory_ui() -> void:
	if battle_ui and is_instance_valid(battle_ui) and battle_ui.end_turn_button and is_instance_valid(battle_ui.end_turn_button):
		battle_ui.end_turn_button.disabled = true
	if player_handler and is_instance_valid(player_handler) and player_handler.hand:
		player_handler.hand.disable_hand()
	
	var popup = _create_victory_popup()
	
	if battle_ui:
		battle_ui.add_child(popup)
	
	popup.show()

func _show_game_over_ui() -> void:
	if battle_ui and is_instance_valid(battle_ui) and battle_ui.end_turn_button and is_instance_valid(battle_ui.end_turn_button):
		battle_ui.end_turn_button.disabled = true
	if player_handler and is_instance_valid(player_handler) and player_handler.hand:
		player_handler.hand.disable_hand()
	
	var popup = _create_game_over_popup()
	battle_ui.add_child(popup)
	popup.show()

func _create_victory_popup() -> Control:
	var popup = Panel.new()
	popup.name = "VictoryPanel"
	popup.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	var bg = ColorRect.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.color = Color(0, 0, 0, 0.8)
	popup.add_child(bg)
	
	var center_container = CenterContainer.new()
	center_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	popup.add_child(center_container)
	
	var victory_panel = Panel.new()
	victory_panel.custom_minimum_size = Vector2(180, 130)
	victory_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	victory_panel.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	center_container.add_child(victory_panel)
	
	var margin = MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	victory_panel.add_child(margin)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 5)
	margin.add_child(vbox)
	
	var title_label = Label.new()
	title_label.text = "VICTORY!"
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	vbox.add_child(title_label)
	
	var subtitle_label = Label.new()
	subtitle_label.text = "Choose a reward:"
	subtitle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(subtitle_label)
	
	var attack_btn = Button.new()
	attack_btn.text = "Attack +1"
	attack_btn.pressed.connect(_on_attack_upgrade_selected.bind(popup))
	vbox.add_child(attack_btn)
	
	var defense_btn = Button.new()
	defense_btn.text = "Defense +1"
	defense_btn.pressed.connect(_on_defense_upgrade_selected.bind(popup))
	vbox.add_child(defense_btn)
	
	return popup

func _create_game_over_popup() -> Control:
	var popup = Panel.new()
	popup.name = "GameOverPanel"
	popup.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	var bg = ColorRect.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.color = Color(0.2, 0, 0, 0.8)
	popup.add_child(bg)
	
	var center_container = CenterContainer.new()
	center_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	popup.add_child(center_container)
	
	var game_over_panel = Panel.new()
	game_over_panel.custom_minimum_size = Vector2(180, 130)
	game_over_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	game_over_panel.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	center_container.add_child(game_over_panel)
	
	var margin = MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	game_over_panel.add_child(margin)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	margin.add_child(vbox)
	
	var title_label = Label.new()
	title_label.text = "GAME OVER"
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	vbox.add_child(title_label)
	
	var restart_btn = Button.new()
	restart_btn.text = "Restart Battle"
	restart_btn.pressed.connect(_on_restart_battle)
	vbox.add_child(restart_btn)
	
	var quit_btn = Button.new()
	quit_btn.text = "Back to Menu"
	quit_btn.pressed.connect(_on_back_to_menu)
	vbox.add_child(quit_btn)
	
	return popup

func _on_attack_upgrade_selected(popup: Control) -> void:
	GameManager.add_attack_bonus(1)
	print("Attack upgrade selected, total bonus: +", GameManager.get_attack_bonus())
	popup.queue_free()
	
	Global.level_number = 0
	get_tree().change_scene_to_file("res://Scenes/fake_map.tscn")

func _on_defense_upgrade_selected(popup: Control) -> void:
	GameManager.add_defense_bonus(1)
	print("Defense upgrade selected, total bonus: +", GameManager.get_defense_bonus())
	popup.queue_free()
	
	Global.level_number = 0
	get_tree().change_scene_to_file("res://Scenes/fake_map.tscn")

func _on_restart_battle() -> void:
	get_tree().reload_current_scene()

func _on_back_to_menu() -> void:
	Global.level_number = 0
	get_tree().change_scene_to_file("res://Scenes/fake_map.tscn")
