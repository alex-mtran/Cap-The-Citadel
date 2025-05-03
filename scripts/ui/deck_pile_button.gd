#extends TextureButton
extends Control

@onready var draw_pile_panel = $DrawPilePanel
@onready var discard_pile_panel = $DiscardPilePanel

func _on_DrawPileButton_pressed():
	draw_pile_panel.visible = not draw_pile_panel.visible

func _on_DiscardPileButton_pressed():
	discard_pile_panel.visible = not discard_pile_panel.visible
