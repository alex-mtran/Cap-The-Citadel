class_name OptionsMenu
extends Control

@onready var exit_button: Button = $MarginContainer/VBoxContainer/ExitButton
@onready var settings_tab_container: Control = $MarginContainer/VBoxContainer/SettingsTabContainer

signal exit_options_menu


func _ready() -> void:
	Events.fake_game_mode = true
	Events.debug_mode = true
	
	exit_button.button_down.connect(on_exit_pressed)
	settings_tab_container.exit_options_menu.connect(on_exit_pressed)
	set_process(false)

func on_exit_pressed() -> void:
	exit_options_menu.emit()
	SettingsSignalBus.emit_set_settings_dictionary(SettingsContainer.create_storage_dictionary())
	set_process(false)
