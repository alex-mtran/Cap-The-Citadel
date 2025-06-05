class_name Treasure
extends Control

@export var treasure_pool: Array[Card]
@export var char_stats: CharacterStats

@onready var animation_player: AnimationPlayer = %AnimationPlayer
var found_treasure: Card


func _ready() -> void:
	if not MainMusic.playing:
		MainMusic.play()
	
	if BattleMusic.playing:
		BattleMusic.stop()

func generate_treasure() -> void:
	found_treasure = treasure_pool.pick_random()

func _on_treasure_opened() -> void:
	# char_stats.deck.add_card(found_treasure)
	Events.treasure_room_exited.emit()

func _on_treasure_chest_gui_input(event: InputEvent) -> void:
	if animation_player.current_animation == "open":
		return

	if event.is_action_pressed("left_mouse"):
		animation_player.play("open")
