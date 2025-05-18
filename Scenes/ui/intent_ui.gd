class_name IntentUI
extends HBoxContainer

@onready var icon: TextureRect = $Icon
@onready var number: Label = $Number

<<<<<<< Updated upstream
func update_intent(intent: Intent) -> void: 
	if not intent:
		hide()
		return
=======
func update_intent(intent: Intent) -> void:
	if not intent:
		hide()
		return
		
>>>>>>> Stashed changes
	icon.texture = intent.icon
	icon.visible = icon.texture != null
	number.text = str(intent.number)
	number.visible = intent.number.length() > 0
	show()
	
<<<<<<< Updated upstream
	
		
=======
>>>>>>> Stashed changes
