extends Button
class_name Exit

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")
