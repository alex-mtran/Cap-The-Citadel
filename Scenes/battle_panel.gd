extends Panel

# Return button
func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/fake_map.tscn")
