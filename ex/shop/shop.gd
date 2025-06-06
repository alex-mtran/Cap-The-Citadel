class_name Shop
extends Control

const SHOP_CARD = preload("res://ex/shop/shop_card.tscn")

@export var char_stats: CharacterStats
@export var run_stats: RunStats

@onready var shop_keeper_animation: AnimationPlayer = %ShopKeeperAnimation
@onready var turn_timer: Timer = %TurnTimer

@onready var cards: HBoxContainer = %Cards
@onready var card_tooltip_popup: CardTooltipPopup = %CardTooltipPopup


func _ready() -> void:
	for shop_card: ShopCard in cards.get_children():
		shop_card.queue_free()

	Events.shop_card_bought.connect(_on_shop_card_bought)

	_turn_timer_setup()
	turn_timer.timeout.connect(_on_turn_timer_timeout)

func _turn_timer_setup() -> void:
	turn_timer.wait_time = randf_range(1.0, 5.0)
	turn_timer.start()

func _on_turn_timer_timeout() -> void:
	shop_keeper_animation.play("turn")
	_turn_timer_setup()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and card_tooltip_popup.visible:
		card_tooltip_popup.hide_tooltip()

func populate_shop() -> void:
	_generate_shop_cards()

func _generate_shop_cards() -> void:
	var shop_card_array: Array[Card] = []
	var available_cards := char_stats.draftable_cards.cards.duplicate(true)
	available_cards.shuffle()
	shop_card_array = available_cards.slice(0, 3)

	for card: Card in shop_card_array:
		var new_shop_card : ShopCard = SHOP_CARD.instantiate()
		cards.add_child(new_shop_card)
		new_shop_card.card = card
		new_shop_card.current_card_ui.tooltip_requested.connect(card_tooltip_popup.show_tooltip)
		new_shop_card.update(run_stats)

func _update_items() -> void:
	for shop_card: ShopCard in cards.get_children():
		shop_card.update(run_stats)

func _on_back_button_pressed() -> void:
	Events.shop_exited.emit()

func _on_shop_card_bought(card: Card, gold_cost: int) -> void:
	char_stats.deck.add_card(card)
	run_stats.gold -= gold_cost
	_update_items()
