class_name IntentUI
extends HBoxContainer

@onready var icon: TextureRect = $Control/Icon
@onready var label: Label = $Control/Label


func update_intent(intent: Intent) -> void:
		if not intent:
			hide()
			return
		
		icon.texture = intent.icon
		icon.visible = icon.texture != null
		label.text = intent.base_text
		show()
	
