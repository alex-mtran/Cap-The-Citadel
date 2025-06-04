class_name MapGenerator  
extends Node  
 
const X_DIST := 30
const Y_DIST := 25
const PLACEMENT_RANDOMNESS := 5
const FLOORS := 4
const MAP_WIDTH := 5
const PATHS := 5
const MONSTER_ROOM_WEIGHT := 10.0

var random_room_type_weights = {  
	Room.Type.MONSTER: 0.0  
}
var random_room_type_total_weights := 0
var map_data: Array[Array]

func generate_map() -> Array[Array]:
	map_data = generate_initial_grid()
	var starting_points := get_rand_start_point()

	for j in starting_points:
		var current_j := j
		for i in FLOORS - 1:
			current_j = setup_connection(i, current_j)
			
	setup_boss_room()
	setup_random_room_weights()
	setup_room_types()
	
	var i:=0

	for floor in map_data:
		print("floor %s" % i)
		var used_rooms = floor.filter(
			func(room: Room): return room.next_rooms.size() > 0
		)
		print(used_rooms)
		i += 1
	
	return map_data
	
func generate_initial_grid() -> Array[Array]:
	var result: Array[Array] = []
	
	for i in FLOORS:
		var adjacent_rooms: Array[Room] = []
		
		for j in MAP_WIDTH:
			var current_room := Room.new()
			# Generate a small random offset for room placement (to avoid perfect grid alignment)  
			var offset := Vector2(randf(), randf()) * PLACEMENT_RANDOMNESS
			# Set the room's position based on grid coordinates (j = column, i = row) with random offset
			current_room.position = Vector2(j * X_DIST, i * -Y_DIST) + offset
			# Assign the room's row 
			current_room.row = i
			current_room.column = j 
			# Initialize an empty array for connected rooms
			current_room.next_rooms = []
			#boss room is set y (not random)
			if i == FLOORS - 1:
				current_room.position.y = (i+1) * -Y_DIST
				
			adjacent_rooms.append(current_room)
			
		result.append(adjacent_rooms)
	return result

func get_rand_start_point() -> Array[int]:
	var y_coordinates: Array[int]
	var unique_points: int = 0
	
	while unique_points < 2:
		unique_points = 0
		y_coordinates = []
		for i in PATHS:
			var starting_point := randi_range(0, MAP_WIDTH - 1)
			if not y_coordinates.has(starting_point):
				unique_points += 1
				y_coordinates.append(starting_point)
	return y_coordinates

func setup_connection(i: int, j: int) -> int:
	var next_room: Room 
	var current_room := map_data[i][j] as Room 

	# Keep searching for a valid next room until we find one that:
	# 1. Exists (not null) AND 
	# 2. Doesn't cross existing paths
	while not next_room or would_cross_existing_path(i, j, next_room):
		# Get random adjacent column  within map bounds
		var random_j := clampi(randi_range(j - 1, j + 1), 0, MAP_WIDTH - 1)
		next_room = map_data[i + 1][random_j]  # Room directly below in next floor
	# Connect the rooms
	current_room.next_rooms.append(next_room)
	return next_room.column
	
func would_cross_existing_path(i: int, j: int, room: Room) -> bool:
	# Will store the room to the left/right
	var left_neighbour: Room  
	var right_neighbour: Room  
	# Get left neighbor if we're not at the left edge (j > 0)
	if j > 0:
		left_neighbour = map_data[i][j - 1]
	# Get right neighbor if we're not at the right edge (j < MAP_WIDTH - 1)
	if j < MAP_WIDTH - 1:
		right_neighbour = map_data[i][j + 1]
	# Check for path crossings with right neighbor
	if right_neighbour and room.column > j:  # If moving right
		for next_room: Room in right_neighbour.next_rooms:
			if next_room.column < room.column:  # If neighbor path goes left
				return true  # Paths would cross
	# Check for path crossings with left neighbor
	if left_neighbour and room.column < j:  # If moving left
		for next_room:Room in left_neighbour.next_rooms:
			if next_room.column > room.column:  # If neighbor path goes right
				return true  # Paths would cross
	# If no crossings detected
	return false

func setup_boss_room() -> void:
	# Place boss room in the center of the bottom floor
	var middle := floori(MAP_WIDTH * 0.5)
	var boss_room := map_data[FLOORS - 1][middle] as Room  # Get bottom-center room

	# Connect all rooms from the floor above to the boss room
	for j in MAP_WIDTH:
		var current_room = map_data[FLOORS - 2][j] as Room  # Get room from floor above
		if current_room.next_rooms:  # Clear existing connections if any
			current_room.next_rooms = [] as Array[Room]
			current_room.next_rooms.append(boss_room)  # Connect to boss room
	# Set the room type
	boss_room.type = Room.Type.MONSTER

func setup_random_room_weights() -> void:
	# Set up weighted probabilities for random room generation
	random_room_type_weights[Room.Type.MONSTER] = MONSTER_ROOM_WEIGHT
	

func setup_room_types() -> void:
	# Set all connected rooms to monster type
	for current_floor in map_data:
		for room: Room in current_floor:
			if room.next_rooms.size() > 0:
				room.type = Room.Type.MONSTER
				
func _room_has_parent_of_type(room: Room, type: Room.Type) -> bool:
	var parents: Array[Room] = []
	# left parent
	if room.column > 0 and room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column - 1] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	# parent below
	if room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	# right parent
	if room.column < MAP_WIDTH-1 and room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column + 1] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	
	for parent: Room in parents:
		if parent.type == type:
			return true
	
	return false

func _get_random_room_type_by_weight() -> Room.Type:
	var roll := randf_range(0.0, random_room_type_total_weights)
	
	for type: Room.Type in random_room_type_weights:
		if random_room_type_weights[type] > roll:
			return type
	
	return Room.Type.MONSTER
