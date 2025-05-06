class_name BattleManager
extends Node

@export var player: Player
@export var hand: Hand
@export_file("*.tscn") var card_ui_scene_path: String

var battle_active: bool = false

func _ready() -> void:
	# Start the battle after a short delay
	await get_tree().create_timer(0.5).timeout
	start_battle()

func start_battle() -> void:
	print("Battle started!")
	battle_active = true
	
	# Clear any existing cards in hand
	clear_hand()
	
	# Initialize player's draw pile from deck
	if player and player.stats:
		# Clear draw and discard piles first to avoid duplicate cards
		player.stats.draw_pile.clear()
		player.stats.discard.clear()
		
		# Copy cards from deck to draw pile
		for card in player.stats.deck.cards:
			player.stats.draw_pile.add_card(card)
		
		player.stats.draw_pile.shuffle()
		
		# Explicitly reset energy
		player.stats.reset_energy()
		print("Energy set to: ", player.stats.energy, "/", player.stats.max_energy)
		
		# Draw initial hand (just 2 cards)
		draw_cards(2)  # Override cards_per_turn with fixed value of 2
	else:
		print("ERROR: Player or player stats not set!")

func draw_cards(amount: int) -> void:
	print("Drawing ", amount, " cards")
	if not player or not player.stats:
		return
	
	for i in range(amount):
		if player.stats.draw_pile.empty() and player.stats.discard.empty():
			break
		
		if player.stats.draw_pile.empty():
			reshuffle_discard_into_draw_pile()
			
		if player.stats.draw_pile.empty():
			break
			
		var card = player.stats.draw_pile.draw_card()
		add_card_to_hand(card)

func reshuffle_discard_into_draw_pile() -> void:
	if not player or not player.stats:
		return
	
	print("Reshuffling discard pile into draw pile")
	while not player.stats.discard.empty():
		var card = player.stats.discard.draw_card()
		player.stats.draw_pile.add_card(card)
	
	player.stats.draw_pile.shuffle()

func add_card_to_hand(card: Card) -> void:
	if not hand:
		print("ERROR: Hand not set!")
		return
	
	# Use the exported scene path
	var card_ui_scene = load(card_ui_scene_path)
	if not card_ui_scene:
		push_error("Failed to load CardUI scene at path: " + card_ui_scene_path)
		return
		
	var card_ui = card_ui_scene.instantiate()
	hand.add_child(card_ui)
	
	# Configure the card UI
	card_ui.card = card
	card_ui.char_stats = player.stats
	card_ui.parent = hand
	print("Added card to hand: ", card.id)

func clear_hand() -> void:
	if not hand:
		return
	
	# Remove all card UIs from the hand
	for child in hand.get_children():
		if child is CardUI:
			child.queue_free()
	
	print("Hand cleared")
