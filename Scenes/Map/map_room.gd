class_name MapRoom
extends Area2D

signal clicked(room: Room)
signal selected(room: Room)

# Dictionary mapping room types to their corresponding icons and scale factors
const ICONS := {
	Room.Type.NOT_ASSIGNED: [null, Vector2.ONE],  # No icon for unassigned rooms
	Room.Type.MONSTER: [preload("res://Assets/Images/monsterRoom.png"), Vector2.ONE],  # Monster icon
}

# Node references (initialized when ready)
@onready var sprite_2d: Sprite2D = $Visuals/Sprite2D  # Sprite for room icon
@onready var line_2d: Line2D = $Visuals/Line2D  # Line for connections
@onready var animation_player: AnimationPlayer = $AnimationPlayer  # For visual effects

# Properties with setters
var available := false : set = set_available  
var room: Room:  set = set_room  # Calls set_room() when changed

	
func set_available(new_value: bool)->void:
	available = new_value
	
	if available:
		animation_player.play("highlightMap")
	elif not room.selected:
		animation_player.play("RESET")

func set_room(new_data: Room) -> void:
	# Update the room data and visual representation
	room = new_data
	position = room.position  # Set node position to room's position
	line_2d.rotation_degrees = randi_range(0, 360)  # Random rotation for visual variety
	sprite_2d.texture = ICONS[room.type][0]  # Set icon based on room type
	sprite_2d.scale = ICONS[room.type][1]  # Apply custom scale from ICONS dictionary
	
func show_selected() -> void:
	line_2d.modulate = Color.WHITE  # Reset to white color (full visibility)

	
#when select finishes
func on_map_room_select() -> void: 
	selected.emit(room)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not available or not event.is_action_pressed("left_mouse"):
		return

	room.selected = true
	clicked.emit(room)
	animation_player.play("selectMap")
