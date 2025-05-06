extends TextureButton

func _on_pressed() -> void:
    var battle = get_tree().current_scene
    var player_handler = battle.get_node("PlayerHandler")
    var battle_ui = get_parent()
    
    var popup = battle_ui.get_node_or_null("DeckViewPanel")
    var title_label
    var grid
    
    if not popup:
        popup = Panel.new()
        popup.name = "DeckViewPanel"
        popup.set_anchors_preset(Control.PRESET_FULL_RECT)
        
        var bg = ColorRect.new()
        bg.set_anchors_preset(Control.PRESET_FULL_RECT)
        bg.color = Color(0.1, 0.28, 0.12, 0.85)
        popup.add_child(bg)
        
        var margin = MarginContainer.new()
        margin.set_anchors_preset(Control.PRESET_FULL_RECT)
        margin.add_theme_constant_override("margin_left", 5)
        margin.add_theme_constant_override("margin_top", 5)
        margin.add_theme_constant_override("margin_right", 5)
        margin.add_theme_constant_override("margin_bottom", 5)
        popup.add_child(margin)
        
        var vbox = VBoxContainer.new()
        vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
        margin.add_child(vbox)
        
        var top_container = HBoxContainer.new()
        vbox.add_child(top_container)
        
        var close_btn = Button.new()
        close_btn.text = "X"
        close_btn.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
        close_btn.custom_minimum_size = Vector2(30, 20)
        close_btn.pressed.connect(func(): 
            popup.hide()
            var hand = battle_ui.get_node("Hand")
            if hand:
                for card_ui in hand.get_children():
                    if card_ui.card != null and card_ui.char_stats != null:
                        card_ui.playable = card_ui.char_stats.can_play_card(card_ui.card)
        )
        top_container.add_child(close_btn)
        
        title_label = Label.new()
        title_label.name = "TitleLabel"
        title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        top_container.add_child(title_label)
        
        var scroll = ScrollContainer.new()
        scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
        vbox.add_child(scroll)
        
        grid = GridContainer.new()
        grid.name = "CardsGrid"
        grid.columns = 7
        grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
        scroll.add_child(grid)
        
        battle_ui.add_child(popup)
    else:
        title_label = popup.find_child("TitleLabel", true, false)
        grid = popup.find_child("CardsGrid", true, false)
    
    if not grid:
        print("ERROR: Could not find CardsGrid node")
        return
        
    for child in grid.get_children():
        child.queue_free()
    
    title_label.text = "Discard Pile"
    
    var card_ui_scene = load("res://Scenes/ui/card_ui.tscn")
    for card in player_handler.character.discard.cards:
        var card_instance = card_ui_scene.instantiate()
        grid.add_child(card_instance)
        card_instance.card = card
        card_instance.disabled = true
    
    popup.show()