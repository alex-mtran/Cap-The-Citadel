class_name Player
extends Node2D

@export var stats: CharacterStats : set = set_character_stats
const WHITE_FLASH = preload("res://enemies/white_flash.tres")

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var stats_ui: StatsUI = $StatsUI as StatsUI
@onready var sfx_player: AudioStreamPlayer = $HitSFX


func set_character_stats(value: CharacterStats) -> void:
	stats = value

	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)

	update_player()

func update_player() -> void:
	if not stats is CharacterStats:
		return
	if not is_inside_tree():
		await ready
	sprite_2d.texture = stats.art
	update_stats()

func update_stats() -> void:
	stats_ui.update_stats(stats)

func take_damage(damage: int) -> void:
	sfx_player.play()
	
	if stats.health <= 0:
		return

	sprite_2d.material = WHITE_FLASH

	var tween := create_tween()
	tween.tween_callback(Shaker.shake.bind(self, 16, 0.15))
	tween.tween_callback(stats.take_damage.bind(damage))
	tween.tween_interval(0.17)
	
	tween.finished.connect(
		func():
			sprite_2d.material = null

			if stats.health <= 0:
				Events.player_died.emit()
				await get_tree().create_timer(0.1).timeout
				queue_free()
	)
