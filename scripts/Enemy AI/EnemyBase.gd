class_name EnemyBase
extends Node

enum EnemyType {BASIC, ELITE, BOSS}
enum BehaviorType {ATTACK, DEFEND, BUFF, DEBUFF}

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

#func _init(_name: String, _hp: int) -> void:
	#name1 = _name
	#health = _hp
	
func perform_action() -> void:
	if !is_performable():
		return

func is_performable() -> bool:
	return !behavior.is_empty()

func get_current_behavior() -> Dictionary:
	return behavior[turn_index % behavior.size()]

func get_intent_text() -> void:
	var a = get_current_behavior()
	match a.type:
		BehaviorType.ATTACK:
			intent_image.texture = load("res://Assets/Images/Attack.png")
		BehaviorType.DEFEND:
			intent_image.texture = load("res://Assets/Images/Defense.png")
		BehaviorType.BUFF:
			intent_image.texture = load("res://Assets/Images/Heart.png")
		BehaviorType.DEBUFF:
			intent_image.texture = load("res://Assets/Images/cowboy_spritesheet.png")
			
	a = get_current_behavior()
	turn_index += 1
