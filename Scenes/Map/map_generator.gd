class_name MapGenerator  
extends Node  
 
const X_DIST := 30   
const Y_DIST := 25   
const PLACEMENT_RANDOMNESS := 5   
const FLOORS := 10
const MAP_WIDTH := 7
const PATHS := 6
const MONSTER_ROOM_WEIGHT := 10.0
const SHOP_ROOM_WEIGHT := 2.5
const CAMPFIRE_ROOM_WEIGHT := 4.0

@export var battle_stats_pool: BattleStatsPool

var random_room_type_weights = {  
	Room.Type.MONSTER: 0.0,
	Room.Type.CAMPFIRE: 0.0,
	Room.Type.SHOP: 0.0
}
var random_room_type_total_weights := 0.0
var map_data: Array[Array]


func generate_map() -> Array[Array]:
	map_data = _generate_initial_grid()
	var starting_points := _get_rand_start_point()

	for j in starting_points:
		var current_j := j
		for i in FLOORS - 1:
			current_j = _setup_connection(i, current_j)

	battle_stats_pool.setup()

	_setup_boss_room()
	_setup_random_room_weights()
	_setup_room_types()

	return map_data

func _generate_initial_grid() -> Array[Array]:
	var result: Array[Array] = []

	for i in FLOORS:
		var adjacent_rooms: Array[Room] = []

		for j in MAP_WIDTH:
			var current_room := Room.new()
			var offset := Vector2(randf(), randf()) * PLACEMENT_RANDOMNESS
			current_room.position = Vector2(j * X_DIST, i * -Y_DIST) + offset
			current_room.row = i
			current_room.column = j 
			current_room.next_rooms = [] # Initialize an empty array for connected rooms

			if i == FLOORS - 1: # Make boss room further from previous nodes
				current_room.position.y = (i + 1) * -Y_DIST

			adjacent_rooms.append(current_room)

		result.append(adjacent_rooms)
	return result

func _get_rand_start_point() -> Array[int]:
	var y_coordinates: Array[int]
	var unique_points: int = 0

	while unique_points < 2: # Have at least two starting points
		unique_points = 0
		y_coordinates = []
		for i in PATHS:
			var starting_point := randi_range(0, MAP_WIDTH - 1)
			if not y_coordinates.has(starting_point):
				unique_points += 1
			y_coordinates.append(starting_point)
	return y_coordinates

func _setup_connection(i: int, j: int) -> int:
	var next_room: Room = null
	var current_room : Room = map_data[i][j]

	while not next_room or _would_cross_existing_path(i, j, next_room):
		var random_j := clampi(randi_range(j - 1, j + 1), 0, MAP_WIDTH - 1)
		next_room = map_data[i + 1][random_j]

	current_room.next_rooms.append(next_room)

	return next_room.column

func _would_cross_existing_path(i: int, j: int, room: Room) -> bool:
	var left_neighbour: Room  
	var right_neighbour: Room  

	if j > 0:
		left_neighbour = map_data[i][j - 1]
	if j < MAP_WIDTH - 1:
		right_neighbour = map_data[i][j + 1]

	if right_neighbour and room.column > j:
		for next_room: Room in right_neighbour.next_rooms:
			if next_room.column < room.column:  # If neighbor path goes left
				return true

	if left_neighbour and room.column < j:
		for next_room: Room in left_neighbour.next_rooms:
			if next_room.column > room.column:
				return true

	return false

func _setup_boss_room() -> void:
	var middle := floori(MAP_WIDTH * 0.5)
	var boss_room : Room = map_data[FLOORS - 1][middle]

	for j in MAP_WIDTH:
		var current_room : Room = map_data[FLOORS - 2][j] # All 2nd to last floors must link to the final boss room
		if current_room.next_rooms:  # Clear existing connections if any
			current_room.next_rooms = [] as Array[Room]
			current_room.next_rooms.append(boss_room)

	boss_room.type = Room.Type.BOSS
	boss_room.battle_stats = battle_stats_pool.get_random_battle_for_tier(2)

func _setup_random_room_weights() -> void:
	random_room_type_weights[Room.Type.MONSTER] = MONSTER_ROOM_WEIGHT
	random_room_type_weights[Room.Type.CAMPFIRE] = MONSTER_ROOM_WEIGHT + CAMPFIRE_ROOM_WEIGHT
	random_room_type_weights[Room.Type.SHOP] = MONSTER_ROOM_WEIGHT + CAMPFIRE_ROOM_WEIGHT + SHOP_ROOM_WEIGHT

	random_room_type_total_weights = random_room_type_weights[Room.Type.SHOP]

func _setup_room_types() -> void:
	for room: Room in map_data[0]: # First floor is all monster rooms
		if room.next_rooms.size() > 0:
			room.type = Room.Type.MONSTER
			room.battle_stats = battle_stats_pool.get_random_battle_for_tier(0)

	for room: Room in map_data[floori(FLOORS / 2)]: # Middle floor is all treasure rooms
		if room.next_rooms.size() > 0:
			room.type = Room.Type.TREASURE

	for room: Room in map_data[FLOORS - 2]: # Last floor before boss room is all campfire rooms
		if room.next_rooms.size() > 0:
			room.type = Room.Type.CAMPFIRE

	for current_floor in map_data:
		for room: Room in current_floor:
			for next_room: Room in room.next_rooms:
				if next_room.type == Room.Type.NOT_ASSIGNED:
					_set_room_randomly(next_room)

func _set_room_randomly(room_to_set: Room) -> void:
	var campfire_below_4 := true
	var consecutive_campfire := true
	var consecutive_shop := true
	var campfire_before_campfire_row := true

	var type_candidate: Room.Type

	while campfire_below_4 or consecutive_campfire or consecutive_shop or campfire_before_campfire_row:
		type_candidate = _get_random_room_type_by_weight()

		var is_campfire := type_candidate == Room.Type.CAMPFIRE
		var has_campfire_parent := _room_has_parent_of_type(room_to_set, Room.Type.CAMPFIRE)
		var is_shop := type_candidate == Room.Type.SHOP
		var has_shop_parent := _room_has_parent_of_type(room_to_set, Room.Type.SHOP)

		campfire_below_4 = is_campfire and room_to_set.row < 3
		consecutive_campfire = is_campfire and has_campfire_parent
		consecutive_shop = is_shop and has_shop_parent
		campfire_before_campfire_row = is_campfire and room_to_set.row == FLOORS - 3 # Floor before the 2nd to last floor which has to be all campfires

	room_to_set.type = type_candidate

	if type_candidate == Room.Type.MONSTER:
		var tier_for_monster_rooms := 0

		if room_to_set.row > floori(FLOORS / 4):
			tier_for_monster_rooms = 1

		room_to_set.battle_stats = battle_stats_pool.get_random_battle_for_tier(tier_for_monster_rooms)

func _room_has_parent_of_type(room: Room, type: Room.Type) -> bool:
	var parents: Array[Room] = []

	if room.column > 0 and room.row > 0: # Left parent
		var parent_candidate : Room = map_data[room.row - 1][room.column - 1]
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)

	if room.row > 0: # Parent below
		var parent_candidate : Room = map_data[room.row - 1][room.column]
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)

	if room.column < MAP_WIDTH - 1 and room.row > 0: # Right parent
		var parent_candidate : Room = map_data[room.row - 1][room.column + 1]
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
