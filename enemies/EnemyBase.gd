class_name EnemyBase
extends Node

enum EnemyType {BASIC, ELITE, BOSS}
enum BehaviorType {ATTACK, DEFEND, BUFF, DEBUFF}

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var arrow: Sprite2D = $Arrow
@onready var stats_ui: StatsUI = $StatsUI as StatsUI

@export var type: EnemyType
@export_range(0.0, 10.0) var chance_weight := 0.0

@onready var accumulated_weight := 0.0

@onready var intent_image: Sprite2D = $IntentIcon
var enemy: SceneMultiplayer
var player: Node 

var name1:String
var health:int
var turn_index := 0
var behavior: Array = []

func get_current_behavior() -> Dictionary:
	return behavior[turn_index % behavior.size()]
	
#func _init(_name: String, _hp: int) -> void:
	#name1 = _name
	#health = _hp
	"""
func perform_action() -> void:
	if !is_performable():
		return

func is_performable() -> bool:
	return !behavior.is_empty()
"""

func action(target: Node) -> void:
	var a = get_current_behavior()
	match a.type:
		BehaviorType.ATTACK:
			target.take_damage(a.value)
		BehaviorType.DEFEND:
			stats_ui.block += a.value
		BehaviorType.BUFF:
			stats_ui.attack += a.value
		BehaviorType.DEBUFF:
			target.stats_ui.attack -= a.value			
	turn_index += 1
