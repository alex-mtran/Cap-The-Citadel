extends Control

const MAP_SCENE : PackedScene = preload("res://scenes/Map/map.tscn")
const BATTLE_SCENE : PackedScene = preload("res://scenes/Battle.tscn")
@onready var start_button: Button = %StartButton
@onready var options_button: Button = %OptionsButton
@onready var load_button: Button = %LoadButton
@onready var exit_button: Button = %ExitButton
@onready var title: VBoxContainer = $MarginContainer/VBoxContainer
@onready var button_choices: HBoxContainer = $MarginContainer/HBoxContainer
@onready var options_menu: OptionsMenu = $OptionsMenu

var in_options : bool = false


func _ready() -> void:
	options_menu.exit_options_menu.connect(on_exit_options_menu)

func _on_start_pressed():
	get_tree().change_scene_to_packed(MAP_SCENE)

func _on_options_pressed() -> void:
	in_options = true
	button_choices.visible = false
	title.visible = false
	options_menu.set_process(true)
	options_menu.visible = true

func _on_load_pressed() -> void:
	print("load logic here")

func _on_exit_pressed() -> void:
	get_tree().quit()

func on_exit_options_menu() -> void:
	title.visible = true
	button_choices.visible = true
	options_menu.visible = false

func _unhandled_key_input(event):
	if not in_options:
		return
	if event.is_action_pressed("ui_cancel"):
		on_exit_options_menu()
