class_name Run
extends Node

const BATTLE_SCENE = preload("res://Scenes/Battle.tscn")
const SHOP_SCENE = preload("res://ex/shop/shop.tscn")
const CAMPFIRE_SCENE = preload("res://ex/campfire/campfire.tscn")
const BATTLE_REWARD_SCENE = preload("res://ex/battle_reward/battle_reward.tscn")
const TREASURE_SCENE = preload("res://ex/treasure/treasure.tscn")

@export var run_startup : RunStartup

@onready var map: Map = $Map
@onready var current_view: Node = $CurrentView
@onready var gold_ui: GoldUI = %GoldUI
@onready var deck_button: CardPileOpener = %DeckButton
@onready var deck_view: CardPileView = %DeckView
@onready var health_ui: HealthUI = %HealthUI

@onready var map_button: Button = %MapButton
@onready var shop_button: Button = %ShopButton
@onready var battle_button: Button = %BattleButton
@onready var rewards_button: Button = %RewardsButton
@onready var campfire_button: Button = %CampfireButton
@onready var treasure_button: Button = %TreasureButton

var stats: RunStats
var character: CharacterStats


func _ready() -> void:
	if not run_startup:
		return
	match run_startup.type:
		RunStartup.Type.NEW_RUN:
			character = run_startup.picked_character.create_instance()
			_start_run()
		RunStartup.Type.CONTINUED_RUN:
			print("TODO: load previous Run")

func _start_run() -> void:
	stats = RunStats.new()

	_setup_event_connections()
	_setup_top_bar()
	map.generate_new_map()
	map.unlock_floor(0)

func _change_view(scene: PackedScene) -> Node:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()

	get_tree().paused = false
	var new_view := scene.instantiate()
	current_view.add_child(new_view)
	map.hide_map()

	return new_view

func _show_map() -> void:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()

	map.show_map()
	map.unlock_next_rooms()

func _setup_event_connections() -> void:
	Events.battle_won.connect(_on_battle_won)
	Events.battle_reward_exited.connect(_show_map)
	Events.campfire_exited.connect(_show_map)
	Events.map_exited.connect(_on_map_exited)
	Events.shop_exited.connect(_show_map)
	Events.treasure_room_exited.connect(_on_treasure_room_exited)

	battle_button.pressed.connect(_change_view.bind(BATTLE_SCENE))
	campfire_button.pressed.connect(_change_view.bind(CAMPFIRE_SCENE))
	map_button.pressed.connect(_show_map)
	rewards_button.pressed.connect(_change_view.bind(BATTLE_REWARD_SCENE))
	shop_button.pressed.connect(_change_view.bind(SHOP_SCENE))
	treasure_button.pressed.connect(_change_view.bind(TREASURE_SCENE))

func _setup_top_bar() -> void:
	character.stats_changed.connect(health_ui.update_stats.bind(character))
	health_ui.update_stats(character)
	gold_ui.run_stats = stats
	deck_button.card_pile = character.deck
	deck_view.card_pile = character.deck
	deck_button.pressed.connect(deck_view.show_current_view.bind("Deck"))

func _on_battle_room_entered(room: Room) -> void:
	var battle_scene: Battle = _change_view(BATTLE_SCENE) as Battle
	battle_scene.char_stats = character
	battle_scene.battle_stats = room.battle_stats
	battle_scene.start_battle()

func _on_treasure_room_entered() -> void:
	var treasure_scene : Treasure = _change_view(TREASURE_SCENE)
	treasure_scene.char_stats = character
	treasure_scene.generate_treasure()

func _on_treasure_room_exited() -> void:
	var reward_scene : BattleReward = _change_view(BATTLE_REWARD_SCENE)
	reward_scene.run_stats = stats
	reward_scene.character_stats = character

	reward_scene.add_card_reward()

func _on_campfire_entered() -> void:
	var campfire := _change_view(CAMPFIRE_SCENE) as Campfire
	campfire.char_stats = character

func _on_shop_entered() -> void:
	var shop : Shop = _change_view(SHOP_SCENE)
	shop.char_stats = character
	shop.run_stats = stats
	shop.populate_shop()

func _on_battle_won() -> void:
	var reward_scene : BattleReward = _change_view(BATTLE_REWARD_SCENE)
	reward_scene.run_stats = stats
	reward_scene.character_stats = character

	reward_scene.add_gold_reward(map.last_room.battle_stats.roll_gold_reward())
	reward_scene.add_card_reward()

func _on_map_exited(room: Room) -> void:
	match room.type:
		Room.Type.MONSTER:
			_on_battle_room_entered(room)
		Room.Type.TREASURE:
			_on_treasure_room_entered()
		Room.Type.CAMPFIRE:
			_on_campfire_entered()
		Room.Type.SHOP:
			_on_shop_entered()
		Room.Type.BOSS:
			_on_battle_room_entered(room)
