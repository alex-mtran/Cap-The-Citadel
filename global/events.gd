extends Node

# Card-related events
signal card_drag_begin(card_ui: CardUI)
signal card_drag_end(card_ui: CardUI)
signal card_aim_begin(card_ui: CardUI)
signal card_aim_end(card_ui: CardUI)	
signal card_played(card: Card)
