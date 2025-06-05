extends Node

# Card-related events
signal card_drag_begin(card_ui: CardUI)
signal card_drag_end(card_ui: CardUI)
signal card_aim_begin(card_ui: CardUI)
signal card_aim_end(card_ui: CardUI)	
signal card_played(card: Card)
signal card_tooltip_requested(card: Card)
signal tooltip_hide_requested

# Player-related events
signal player_hand_drawn
signal player_hand_discarded
signal player_turn_ended
signal player_hit
signal player_died

#Enemy-related Events
signal enemy_action_completed(enemy: Enemy)
signal enemy_turn_ended

# Battle-related events
signal battle_over_screen_requested(text: String, type: BattleOverPanel.Type)
signal battle_won

# Map-related events
signal map_exited(room: Room)
# signal pause_to_map

# Shop-related events
signal shop_exited

# Campfire-related events
signal campfire_exited

# Battle Reward-related events
signal battle_reward_exited

# Treasure Room-related events
signal treasure_room_exited

# Level information
# var level_number = 1
var max_level_unlocked = 1

# Debug flag for testing fake game load/save using database
var debug_mode := false

# SQLite Database
var database: SQLite

# Save and load flags
var saved_game := false
var loaded_game := false
