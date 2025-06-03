class_name Map
extends Node2D

const SCROLL_SPEED := 15  # Speed for camera/scroll movement
const MAP_ROOM = preload("res://Scenes/Map/map_room_2.tscn")  # Room scene reference
const MAP_LINE = preload("res://Scenes/Map/map_line.tscn")  # Connection line scene reference

@onready var map_generator: MapGenerator = $MapGenerator  # Handles map generation logic
@onready var lines: Node2D = %Lines  # Container for connection lines (using unique name)
@onready var rooms: Node2D = %Rooms  # Container for room nodes (using unique name)
@onready var visuals: Node2D = $Visuals  # Parent node for visual elements
@onready var camera_2d: Camera2D = $Camera2D  # Camera for map navigation

# Runtime variables
var map_data: Array[Array]  # 2D array storing the generated map data
var floors_climbed: int  # Tracks how many floors the player has ascended
var last_room: Room  # Reference to the last visited room
var camera_edge_y: float  # Stores vertical camera boundary position

func _ready() -> void:
	get_tree().paused = false
	# Calculate the vertical camera boundary based on map height
	camera_edge_y = MapGenerator.Y_DIST * (MapGenerator.FLOORS - 1)
	
	generate_new_map()
	unlock_floor(0)

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	# Handle scroll input events
	if event.is_action_pressed("scroll_up"):
		camera_2d.position.y -= SCROLL_SPEED  # Move camera up
	elif event.is_action_pressed("scroll_down"):
		camera_2d.position.y += SCROLL_SPEED  # Move camera down
	
	# Clamp camera position to stay within map boundaries
	camera_2d.position.y = clamp(camera_2d.position.y, -camera_edge_y, 0)
	
func generate_new_map() -> void:
	floors_climbed = 0 
	map_data = map_generator.generate_map()
	create_map()
	
func load_map(map: Array[Array], floors_completed: int, last_room_climbed: Room) -> void:
	floors_climbed = floors_completed
	map_data = map
	last_room = last_room_climbed
	create_map()
	
	if floors_climbed > 0:
		unlock_next_rooms()
	else:
		unlock_floor()
	
func create_map()-> void:
	for current_floor:Array in map_data:
		for room: Room in current_floor:
			if room.next_rooms.size() > 0:
				spawn_room(room)
				
	var middle := floori(MapGenerator.MAP_WIDTH * 0.5)
	spawn_room(map_data[MapGenerator.FLOORS-1][middle])
	
	var map_width_pixels := MapGenerator.X_DIST * (MapGenerator.MAP_WIDTH - 1)
	# Center the map visuals horizontally and vertically
	visuals.position.x = (get_viewport_rect().size.x - map_width_pixels) / 2
	visuals.position.y = get_viewport_rect().size.y / 2

func unlock_floor(which_floor: int = floors_climbed) -> void:
	# Make all rooms on the specified floor available
	for map_room: MapRoom2 in rooms.get_children():
		if map_room.room.row == which_floor:
			map_room.available = true  # Enable interaction with this room

func unlock_next_rooms() -> void:
	# Unlock rooms connected to the last visited room
	for map_room: MapRoom2 in rooms.get_children():
		if last_room.next_rooms.has(map_room.room):  # Check if connected to last room
			map_room.available = true  # Make connected room interactable
			
func show_map() -> void:
	hide()
	camera_2d.enabled = true
	
func hide_map()-> void:
	show()
	camera_2d.enabled = false

func spawn_room(room: Room) -> void:
	var new_map_room := MAP_ROOM.instantiate() as MapRoom2
	rooms.add_child(new_map_room)
	new_map_room.room = room
	new_map_room.clicked.connect(on_map_room_clicked)
	new_map_room.selected.connect(on_map_room_selected)
	connect_lines(room)
	
	if room.selected and room.row < floors_climbed:
		new_map_room.show_selected()
		
func connect_lines(room: Room) -> void:
	# Skip if the room has no connections
	if room.next_rooms.is_empty():
		return

	# Create connection lines for each adjacent room
	for next: Room in room.next_rooms:
		var new_map_line := MAP_LINE.instantiate() as Line2D  # Create new line instance
		new_map_line.add_point(room.position)    # Start point at current room
		new_map_line.add_point(next.position)  # End point at connected room
		lines.add_child(new_map_line)  # Add line to the scene
		
func on_map_room_clicked(room: Room) -> void:
	for map_room: MapRoom2 in rooms.get_children():
		if map_room.room.row == room.row:
			map_room.available = false
			
func on_map_room_selected(room: Room) -> void:
	# Disable all rooms on the same floor as the selected room
	for map_room: MapRoom2 in rooms.get_children():
		if map_room.room.row == room.row:  # Check if same floor
			map_room.available = false     # Make room non-interactable
	# Update game state
	last_room = room          # Set as last visited room
	floors_climbed += 1       # Increment floor counter
	#Events.map_exited.emit(room)  # Notify other systems about room exit

# Menu button
func _on_menu_pressed() -> void:
	GameManager.reset_upgrades()
	get_tree().change_scene_to_file("res://menus/main_menu/main_menu.tscn")
