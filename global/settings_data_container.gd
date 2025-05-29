extends Node

@onready var DEFAULT_SETTINGS : DefaultSettingsResource = preload("res://settings/default_settings.tres")

var window_mode_index : int = 0
var resolution_index : int = 0
var master_volume : float = 0.0
var music_volume : float = 0.0
var sfx_volume : float = 0.0

var loaded_data : Dictionary = {}

func _ready() -> void:
	handle_signals()

func create_storage_dictionary() -> Dictionary:
	var settings_container_dict : Dictionary = {
		"window_mode_index" : window_mode_index,
		"resolution_index" : resolution_index,
		"master_volume" : master_volume,
		"music_volume" : music_volume,
		"sfx_volume" : sfx_volume
	}
	return settings_container_dict

func get_window_mode_index() -> int:
	if loaded_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_WINDOW_MODE_INDEX
	return window_mode_index

func get_resolution_index() -> int:
	if loaded_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_RESOLUTION_INDEX
	return resolution_index

func get_master_volume() -> float:
	if loaded_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_MASTER_VOLUME
	return master_volume

func get_music_volume() -> float:
	if loaded_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_MUSIC_VOLUME
	return music_volume

func get_sfx_volume() -> float:
	if loaded_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_SFX_VOLUME
	return sfx_volume

func set_window_mode(index : int) -> void:
	window_mode_index = index

func set_resolution(index : int) -> void:
	resolution_index = index

func set_master_volume(value : float) -> void:
	master_volume = value

func set_music_volume(value : float) -> void:
	music_volume = value

func set_sfx_volume(value : float) -> void:
	sfx_volume = value

func on_settings_data_loaded(data : Dictionary) -> void:
	loaded_data = data
	set_window_mode(loaded_data.window_mode_index)
	set_resolution(loaded_data.resolution_index)
	set_master_volume(loaded_data.master_volume)
	set_music_volume(loaded_data.music_volume)
	set_sfx_volume(loaded_data.sfx_volume)

func handle_signals() -> void:
	SettingsSignalBus.on_window_mode_selected.connect(set_window_mode)
	SettingsSignalBus.on_resolution_selected.connect(set_resolution)
	SettingsSignalBus.on_master_sound_set.connect(set_master_volume)
	SettingsSignalBus.on_music_sound_set.connect(set_music_volume)
	SettingsSignalBus.on_sfx_sound_set.connect(set_sfx_volume)
	SettingsSignalBus.load_settings_data.connect(on_settings_data_loaded)
