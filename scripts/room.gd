class_name Room
extends Resource

enum Type {
	NOT_ASSIGNED, # 0
	MONSTER, # 1
	TREASURE, # 2
	CAMPFIRE, # 3
	SHOP, # 4
	BOSS # 5
}

@export var type: Type
@export var row: int
@export var column: int
@export var position: Vector2
@export var next_rooms: Array[Room]
@export var selected := false
@export var battle_stats: BattleStats # Only used by the MONSTER and BOSS types

func _to_string() -> String:
	return "%s\t(%s)" % [column, Type.keys()[type][0]]
