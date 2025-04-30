#extends Button
extends Control

@onready var discard_panel = $DiscardPanel

func _ready():
	discard_panel.visible = false  # Start hidden

func _on_DiscardPileButton_pressed():
	discard_panel.visible = not discard_panel.visible  # Toggle on click
