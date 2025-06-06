extends Control

const RUN_SCENE = preload("res://ex/run/run.tscn")
const MAP_SCENE : PackedScene = preload("res://ex/map/ex_map.tscn")
const BATTLE_SCENE : PackedScene = preload("res://scenes/Battle.tscn")
const CHAR_SELECTOR_SCENE = preload("res://menus/character_selector/character_selector.tscn")
const PLAYER = preload("res://player/player.tres")

@onready var continue_button: Button = %ContinueButton
@onready var new_run_button: Button = %NewRunButton
@onready var options_button: Button = %OptionsButton
@onready var exit_button: Button = %ExitButton

@onready var title: VBoxContainer = $MarginContainer/VBoxContainer
@onready var button_choices: HBoxContainer = $MarginContainer/HBoxContainer
@onready var options_menu: OptionsMenu = $OptionsMenu
@onready var characters: Control = $Characters

var in_options : bool = false


func _ready() -> void:
	Events.debug_mode = false
	
	print("Debug mode: " + str(Events.debug_mode))
	
	if not MainMusic.playing:
		MainMusic.play()
	
	if BattleMusic.playing:
		BattleMusic.stop()
	
	get_tree().paused = false
	options_menu.exit_options_menu.connect(on_exit_options_menu)

func _on_continue_button_pressed() -> void:
	print("load logic here")

func _on_new_run_button_pressed():
	# Reset everything before starting a new run
	GameState.map_generated = false
	GameState.map_data.clear()
	GameState.floors_climbed = 0
	GameState.last_room = null

	get_tree().change_scene_to_packed(CHAR_SELECTOR_SCENE)
	print("main_menu.gd: Starting new game, cleared map_data. Size now:", GameState.map_data.size())


func _on_options_pressed() -> void:
	in_options = true
	button_choices.visible = false
	title.visible = false
	characters.visible = false
	options_menu.set_process(true)
	options_menu.visible = true

func _on_exit_pressed() -> void:
	get_tree().quit()

func on_exit_options_menu() -> void:
	title.visible = true
	button_choices.visible = true
	characters.visible = true
	options_menu.visible = false

func _unhandled_key_input(event):
	if not in_options:
		return
	if event.is_action_pressed("ui_cancel"):
		on_exit_options_menu()
