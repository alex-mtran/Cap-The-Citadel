class_name PauseMenu
extends CanvasLayer

@onready var restart: Button = %Restart
@onready var map: Button = %Map
@onready var options: Button = %Options
@onready var options_menu: OptionsMenu = $OptionsMenu
@onready var save: Button = %Save
@onready var save_and_quit: Button = %SaveAndQuit

var in_options : bool = false

func _ready() -> void:
	set_process_unhandled_key_input(false)
	options_menu.exit_options_menu.connect(on_exit_options_menu)

func resume() -> void:
	visible = false
	set_process_unhandled_key_input(false)

func _on_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()

func _on_map_pressed() -> void:
	Events.level_number = 0
	get_tree().change_scene_to_file("res://Scenes/Map/map.tscn")
	print("go to map scene")

func _on_options_pressed() -> void:
	in_options = true
	options_menu.visible = true

func _on_save_pressed() -> void:
	print("save logic here")

func _on_save_and_quit_pressed() -> void:
	print("save logic here")
	get_tree().quit()

func on_exit_options_menu() -> void:
	in_options = false
	options_menu.visible = false

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_cancel") and not event.is_echo():
		if not in_options:
			resume()
		else:
			on_exit_options_menu()
		get_viewport().set_input_as_handled()
