class_name PauseMenu
extends CanvasLayer

@onready var restart_run: Button = %RestartRun
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

func _on_restart_run_pressed() -> void:
	resume()
	get_tree().reload_current_scene()

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

func _on_back_pressed() -> void:
	resume()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and in_options:
		on_exit_options_menu()
	elif event.is_action_pressed("ui_cancel"):
		hide()
