class_name Campfire
extends Control

@export var char_stats: CharacterStats

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	if not MainMusic.playing:
		MainMusic.play()
	
	if BattleMusic.playing:
		BattleMusic.stop()

func _on_rest_button_pressed() -> void:
	char_stats.heal(ceili(char_stats.max_health * 0.3))
	animation_player.play("fade_out")

# Called from the AnimationPlayer at the end of 'fade-out'
func _on_fade_out_finished() -> void:
	Events.campfire_exited.emit()
