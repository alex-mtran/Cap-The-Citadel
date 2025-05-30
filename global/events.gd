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
signal player_died

#Enemy-related Events
signal enemy_action_completed(enemy: Enemy)
signal enemy_turn_ended

var level_number = 1
