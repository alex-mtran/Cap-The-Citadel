class_name BattleUI
extends CanvasLayer

@export var char_stats: CharacterStats : set = _set_char_stats

@onready var hand: Hand = $Hand as Hand
@onready var energy_ui: EnergyUI = $EnergyUI as EnergyUI
@onready var end_turn_button: Button = %EndTurnButton
@onready var options_menu: OptionsMenu = $OptionsMenu

var in_options = false

func _ready() -> void:
	Events.player_hand_drawn.connect(_on_player_hand_drawn)
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)

func _process(delta) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		_on_options_pressed()

func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	energy_ui.char_stats = char_stats
	hand.char_stats = char_stats

func _on_player_hand_drawn() -> void:
	end_turn_button.disabled = false

func _on_end_turn_button_pressed() -> void:
	end_turn_button.disabled = true
	Events.player_turn_ended.emit()

# Options button
func _on_options_pressed() -> void: # UNFINISHED
	in_options = true 
	options_menu.set_process(true)
	options_menu.visible = true

# Mute button
func _on_mute_pressed() -> void:
	if not AudioServer.is_bus_mute(AudioServer.get_bus_index("Master")):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)

func on_exit_options_menu() -> void: # UNFINISHED
	options_menu.visible = false

func _unhandled_key_input(event): # UNFINISHED
	if event.is_action_pressed("ui_cancel") and not event.is_echo():
		options_menu.visible = true
		options_menu.set_process_unhandled_key_input(true)
