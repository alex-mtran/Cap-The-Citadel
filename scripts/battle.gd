class_name Battle
extends Control

@export var battle_stats: BattleStats
@export var char_stats: CharacterStats

@onready var battle_ui: BattleUI = $BattleUI as BattleUI
@onready var player_handler: PlayerHandler = $PlayerHandler as PlayerHandler
@onready var enemy_handler: EnemyHandler = $EnemyHandler as EnemyHandler
@onready var player: Player = $Player as Player

@onready var options_button: Button = $BattleUI/Options
@onready var mute_button: Button = $BattleUI/MuteButton
@onready var pause_menu: CanvasLayer = $PauseMenu

var in_options = false


func _ready() -> void:
	if MainMusic.playing:
		MainMusic.stop()

	if BattleMusic.playing:
		BattleMusic.stop()

	if not BattleMusic.playing:
		BattleMusic.play()

	options_button.visible = true
	mute_button.visible = true

	enemy_handler.child_order_changed.connect(_on_enemies_child_order_changed)
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)

	Events.player_turn_ended.connect(player_handler.end_turn)
	Events.player_hand_discarded.connect(enemy_handler.start_turn)
	Events.player_died.connect(_on_player_died)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_handle_window_close()

func _handle_window_close() -> void:
	if Events.enemy_turn_ended.is_connected(_on_enemy_turn_ended):
		Events.enemy_turn_ended.disconnect(_on_enemy_turn_ended)

	if Events.player_turn_ended.is_connected(player_handler.end_turn):
		Events.player_turn_ended.disconnect(player_handler.end_turn)

	if Events.player_hand_discarded.is_connected(enemy_handler.start_turn):
		Events.player_hand_discarded.disconnect(enemy_handler.start_turn)

	if Events.player_died.is_connected(_on_player_died):
		Events.player_died.disconnect(_on_player_died)

	if enemy_handler and enemy_handler.child_order_changed.is_connected(_on_enemies_child_order_changed):
		enemy_handler.child_order_changed.disconnect(_on_enemies_child_order_changed)

	if battle_ui:
		battle_ui.set_process_mode(Node.PROCESS_MODE_DISABLED)
	if player_handler:
		player_handler.set_process_mode(Node.PROCESS_MODE_DISABLED)
	if enemy_handler:
		enemy_handler.set_process_mode(Node.PROCESS_MODE_DISABLED)
	if player:
		player.set_process_mode(Node.PROCESS_MODE_DISABLED)

	get_tree().call_group("enemies", "set_process_mode", Node.PROCESS_MODE_DISABLED)

	get_tree().quit()

func start_battle() -> void:
	get_tree().paused = false

	battle_ui.char_stats = char_stats
	player.stats = char_stats
	enemy_handler.setup_enemies(battle_stats)
	enemy_handler.reset_enemy_actions()

	player_handler.start_battle(char_stats)
	battle_ui.initialize_card_pile_ui()

func _on_enemies_child_order_changed() -> void: 
	if enemy_handler.get_child_count() == 0:
		if options_button:
			options_button.visible = false

		if mute_button:
			mute_button.visible = false

		Events.battle_over_screen_requested.emit("Victorious!", BattleOverPanel.Type.WIN)

func _on_enemy_turn_ended() -> void:
	player_handler.start_turn()
	enemy_handler.reset_enemy_actions()
	
func _on_player_died() -> void:
	if options_button:
		options_button.visible = false
	
	if mute_button:
		mute_button.visible = false

	Events.battle_over_screen_requested.emit("Game Over!", BattleOverPanel.Type.LOSE)

# Options button
func _on_options_pressed() -> void:
	in_options = true 
	pause_menu.set_process(true)
	pause_menu.visible = true

func on_exit_options_menu() -> void:
	pause_menu.visible = false
