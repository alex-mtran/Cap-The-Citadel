class_name BattleOverPanel
extends Panel

enum Type {WIN, LOSE}

@onready var label: Label = %Label
@onready var continue_button: Button = %ContinueButton
@onready var restart_button: Button = %RestartButton


func _ready() -> void:
	continue_button.pressed.connect(_show_victory_ui)
	continue_button.pressed.connect(func(): Events.battle_won.emit())
	restart_button.pressed.connect(_on_restart_battle)
	Events.battle_over_screen_requested.connect(show_screen)

func show_screen(text: String, type: Type) -> void:
	label.text = text
	continue_button.visible = type == Type.WIN
	restart_button.visible = type == Type.LOSE
	show()
	get_tree().paused = true

func _show_victory_ui() -> void:
	var popup = _create_victory_popup()
	get_parent().add_child(popup)

	popup.show()

func _show_game_over_ui() -> void:
	var popup = _create_game_over_popup()
	get_parent().add_child(popup)
	popup.show()

func _create_victory_popup() -> Control:
	var popup = Panel.new()
	popup.process_mode = Node.PROCESS_MODE_ALWAYS
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
	
	# var title_label = Label.new()
	# title_label.text = "VICTORY!"
	# title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	# title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	# vbox.add_child(title_label)
	
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
	popup.process_mode = Node.PROCESS_MODE_ALWAYS
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
	title_label.text = "IT'S NOT OVER YET"
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	vbox.add_child(title_label)
	
	var restart_btn = Button.new()
	restart_btn.text = "Try Again"
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
	
	if Events.level_number == Events.max_level_unlocked:
		Events.max_level_unlocked += 1
	
	Events.level_number += 1
	
	get_tree().paused = false
	
	if not Events.debug_mode:
		get_tree().change_scene_to_file("res://Scenes/Map/map.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/fake_map.tscn")

func _on_defense_upgrade_selected(popup: Control) -> void:
	GameManager.add_defense_bonus(1)
	print("Defense upgrade selected, total bonus: +", GameManager.get_defense_bonus())
	popup.queue_free()

	if Events.level_number == Events.max_level_unlocked:
		Events.max_level_unlocked += 1

	Events.level_number += 1

	get_tree().paused = false

	if not Events.debug_mode:
		get_tree().change_scene_to_file("res://Scenes/Map/map.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/fake_map.tscn")

func _on_restart_battle() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_back_to_menu() -> void:
	get_tree().paused = false
	
	if not Events.debug_mode:
		get_tree().change_scene_to_file("res://Scenes/Map/map.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/fake_map.tscn")
