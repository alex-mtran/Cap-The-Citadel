class_name SettingsTabContainer
extends Control

@onready var tab_container : TabContainer = $TabContainer

signal exit_options_menu

func _process(_delta):
	options_menu_input()

func options_menu_input() -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		exit_options_menu.emit()
