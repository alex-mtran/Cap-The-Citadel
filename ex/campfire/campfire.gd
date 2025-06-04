extends Control

func _ready() -> void:
	if not MainMusic.playing:
		MainMusic.play()
	
	if BattleMusic.playing:
		BattleMusic.stop()

func _on_button_pressed() -> void:
	Events.campfire_exited.emit()
